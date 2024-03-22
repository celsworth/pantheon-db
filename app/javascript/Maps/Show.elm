port module Maps.Show exposing (main)

import Api.Enum.LocationCategory exposing (LocationCategory(..))
import Api.Enum.ResourceResource exposing (ResourceResource(..))
import Browser
import Browser.Dom
import Browser.Events
import Helpers
import Helpers.StringFilter
import Html exposing (..)
import Html.Attributes exposing (class, id, placeholder, step, style, type_, value)
import Html.Events exposing (onCheck, onClick, onInput)
import Html.Events.Extra.Mouse as Mouse
import Html.Events.Extra.Pointer as Pointer
import Html.Events.Extra.Wheel as Wheel
import Html.Lazy
import List.Extra
import Maps.CoordTranslations
import Maps.Test
import Query.Common
import Query.Locations
import Query.Monsters
import Query.Npcs
import Query.Resources
import Round
import Svg exposing (Svg, svg)
import Svg.Attributes
import Svg.Lazy
import Task
import Types exposing (Location, Monster, Npc, Resource)
import VirtualDom


type alias ViewFlags =
    { x : Maybe String
    , y : Maybe String
    , zoom : Maybe String
    }


type alias Flags =
    { graphqlBaseUrl : String, view : ViewFlags, guildMember : Bool }


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Offset =
    { x : Float
    , y : Float
    }


maxZoom : number
maxZoom =
    20


zoomStep : Float
zoomStep =
    0.5


mapXSize : number
mapXSize =
    3840


mapYSize : number
mapYSize =
    2880


type alias MapCalcInput =
    { loc : Offset
    , map : Offset
    }


type alias MapCalibration =
    { xLeft : Float
    , yBottom : Float
    , xScale : Float
    , yScale : Float
    }


type alias PoiVisibility =
    { -- contents of lists are selected as visible in sidebar
      resources : List Api.Enum.ResourceResource.ResourceResource
    , locations : List Api.Enum.LocationCategory.LocationCategory
    }


defaultPoiVisibility : PoiVisibility
defaultPoiVisibility =
    { -- all on by default
      resources = Api.Enum.ResourceResource.list
    , locations = Api.Enum.LocationCategory.list
    }


type alias MapLayer =
    -- id, visible
    { id : String, label : String, visible : Bool }


type alias MapLayers =
    List MapLayer


type alias MapPoiData =
    { locations : List Location
    , monsters : List Monster
    , npcs : List Npc
    , resources : List Resource
    }


type alias PoiFilter =
    { searchText : Maybe String
    , namedOnly : Bool
    }


type alias Model =
    { flags : Flags
    , mapCalibration : MapCalibration
    , mapLayers : MapLayers
    , zoom : Float
    , mapOffset : Offset
    , svgElementSize : Offset
    , mousePosition : Offset
    , dragData : DragData
    , poiVisibility : PoiVisibility
    , poiHover : Maybe ( HoverType, Poi )
    , poiFilter : PoiFilter
    , mapPoiData : MapPoiData
    , filteredMapPoiData : MapPoiData
    , sidePanelTabSelected : ObjectType
    }


type HoverType
    = MapHover
    | SidebarHover


type ObjectType
    = Npc
    | Monster
    | Resource
    | Location


type Poi
    = PoiNpc Npc
    | PoiResource Resource
    | PoiMonster Monster
    | PoiLocation Location


type DragData
    = NotDragging
    | Dragging { startingMapOffset : Offset, startingMousePos : Offset }


type FilterType
    = NamedOnly Bool


type Msg
    = MouseWheel Wheel.Event
    | PointerDown Pointer.Event
    | PointerMove Pointer.Event
    | PointerUp Pointer.Event
    | ZoomChanged String
    | GotNpcs (Query.Common.Msg Npc)
    | GotMonsters (Query.Common.Msg Monster)
    | GotResources (Query.Common.Msg Resource)
    | GotLocations (Query.Common.Msg Location)
    | BrowserResized
    | GotSvgElement (Result Browser.Dom.Error Browser.Dom.Element)
    | ClickedPoi Poi
    | PoiHoverEnter HoverType Poi Mouse.Event
    | PoiHoverLeave Mouse.Event
    | ChangeSidePanelTab ObjectType
    | SetSearchText String
    | ChangePoiResourceVisibility (List Api.Enum.ResourceResource.ResourceResource)
    | ChangePoiLocationVisibility (List Api.Enum.LocationCategory.LocationCategory)
    | SetPoiVisibility ObjectType Bool
    | SetFilter FilterType
    | ToggleMapLayer MapLayer


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        calibrationInput1 =
            -- tavern keeper
            { loc = { x = 3454.23, y = 3729 }
            , map = { x = 1802, y = 1361 }
            }

        calibrationInput2 =
            -- oceanside portal
            { loc = { x = 4746.07, y = 2856.59 }
            , map = { x = 2278.33, y = 1683.81 }
            }

        pngcalibrationInput1 =
            -- tavern keeper
            { loc = { x = 3454.23, y = 3729 }
            , map = { x = 1308.2, y = 1112.1 }
            }

        pngcalibrationInput2 =
            -- oceanside portal
            { loc = { x = 4746.07, y = 2856.59 }
            , map = { x = 3087.02, y = 2316.98 }
            }

        mapPoiData =
            { locations = [], monsters = [], npcs = [], resources = [] }

        flagDefault default input =
            input |> Maybe.withDefault (String.fromFloat default) |> String.toFloat |> Maybe.withDefault default
    in
    ( { flags = flags
      , mapCalibration = calcMapCalibration calibrationInput1 calibrationInput2
      , mapLayers =
            [ { id = "Karta 1: Bakgrund", label = "Background", visible = True }
            , { id = "Karta 1: Island", label = "Island", visible = True }
            , { id = "Karta 1: Water P", label = "Water", visible = True }
            , { id = "Karta 1: Portal P", label = "Portal", visible = True }
            , { id = "Karta 1: House P", label = "House", visible = True }
            , { id = "Karta 1: Edge L", label = "Edge", visible = True }
            , { id = "Karta 1: Fence", label = "Fence", visible = True }
            , { id = "Karta 1: Wood Bridge", label = "Wood Bridge", visible = True }
            , { id = "Karta 1: Small caves", label = "Small caves", visible = True }
            , { id = "Karta 1: Castle P", label = "Castle", visible = True }
            , { id = "Karta 1: Dark Stone Building", label = "Dark Stone Building", visible = True }
            , { id = "Karta 1: Road L", label = "Road", visible = True }
            , { id = "Karta 1: Redline", label = "Red line (invisible wall)", visible = True }
            ]
      , zoom = flagDefault 1 flags.view.zoom
      , mapOffset = { x = flagDefault 0 flags.view.x, y = flagDefault 0 flags.view.y }
      , mousePosition = { x = 0, y = 0 }
      , svgElementSize = { x = 0, y = 0 }
      , dragData = NotDragging
      , poiVisibility = defaultPoiVisibility
      , poiHover = Nothing
      , poiFilter = { searchText = Nothing, namedOnly = False }
      , mapPoiData = mapPoiData
      , filteredMapPoiData = mapPoiData
      , sidePanelTabSelected = Monster
      }
    , Cmd.batch
        [ Query.Npcs.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotNpcs }
        , Query.Monsters.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotMonsters }
        , Query.Resources.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotResources }
        , Query.Locations.makeRequest { hasLocCoords = Just True } { url = flags.graphqlBaseUrl, toMsg = GotLocations }
        , Browser.Dom.getElement "svg-container" |> Task.attempt GotSvgElement
        ]
    )


calcMapCalibration : MapCalcInput -> MapCalcInput -> MapCalibration
calcMapCalibration input1 input2 =
    let
        xScale =
            (input1.map.x - input2.map.x) / (input1.loc.x - input2.loc.x)

        yScale =
            (input1.map.y - input2.map.y) / (input1.loc.y - input2.loc.y)

        xLeft =
            input1.loc.x - (input1.map.x / xScale)

        yBottom =
            input1.loc.y - (input1.map.y / yScale)
    in
    { xLeft = xLeft, yBottom = yBottom, xScale = abs xScale, yScale = abs yScale }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNpcs response ->
            let
                mapPoiData =
                    model.mapPoiData

                newMapPoiData =
                    { mapPoiData | npcs = Query.Common.parseList response }
            in
            ( { model | mapPoiData = newMapPoiData } |> updateMapPoiData, Cmd.none )

        GotMonsters response ->
            let
                mapPoiData =
                    model.mapPoiData

                newMapPoiData =
                    { mapPoiData | monsters = Query.Common.parseList response }
            in
            ( { model | mapPoiData = newMapPoiData } |> updateMapPoiData, Cmd.none )

        GotResources response ->
            let
                mapPoiData =
                    model.mapPoiData

                newMapPoiData =
                    { mapPoiData | resources = Query.Common.parseList response }
            in
            ( { model | mapPoiData = newMapPoiData } |> updateMapPoiData, Cmd.none )

        GotLocations response ->
            let
                mapPoiData =
                    model.mapPoiData

                newMapPoiData =
                    { mapPoiData | locations = Query.Common.parseList response }
            in
            ( { model | mapPoiData = newMapPoiData } |> updateMapPoiData, Cmd.none )

        MouseWheel event ->
            model |> applyMouseWheelZoom event |> updateUrl

        ZoomChanged value ->
            model
                |> changeZoom { xProp = 0.5, yProp = 0.5 } (value |> String.toFloat |> Maybe.withDefault 1)
                |> updateUrl

        PointerDown event ->
            let
                _ =
                    Debug.log "PointerDown" event.pointer

                _ =
                    Debug.log "svgCoords" <| Maps.CoordTranslations.clickPositionToSvgCoordinates event.pointer.offsetPos mapXSize mapYSize model.svgElementSize model.mapOffset model.zoom
            in
            ( { model
                | dragData =
                    Dragging
                        { startingMapOffset = model.mapOffset
                        , startingMousePos = mouseEventToOffset event.pointer
                        }
              }
            , preventScrolling True
            )

        PointerMove event ->
            ( model |> calculateNewMapOffset event.pointer |> setMousePosition event.pointer, Cmd.none )

        PointerUp _ ->
            { model | dragData = NotDragging } |> updateUrl |> appendCmd (preventScrolling False)

        BrowserResized ->
            ( model, Browser.Dom.getElement "svg-container" |> Task.attempt GotSvgElement )

        GotSvgElement (Ok element) ->
            let
                newMapPageSize =
                    { x = element.element.width, y = element.element.height }
            in
            ( { model | svgElementSize = newMapPageSize }, Cmd.none )

        GotSvgElement (Err _) ->
            ( model, Cmd.none )

        PoiHoverEnter hoverType poi _ ->
            ( { model | poiHover = Just ( hoverType, poi ) }, Cmd.none )

        PoiHoverLeave _ ->
            ( { model | poiHover = Nothing }, Cmd.none )

        ClickedPoi target ->
            let
                _ =
                    Debug.log "ClickedPoi" target
            in
            ( model, Cmd.none )

        SetSearchText searchText ->
            let
                maybeSearchText =
                    Helpers.maybeIf (not <| String.isEmpty searchText) searchText

                poiFilter =
                    model.poiFilter

                newPoiFilter =
                    { poiFilter | searchText = maybeSearchText }
            in
            ( { model | poiFilter = newPoiFilter } |> updateMapPoiData, Cmd.none )

        ChangeSidePanelTab toTab ->
            ( { model | sidePanelTabSelected = toTab } |> updateMapPoiData, Cmd.none )

        ChangePoiResourceVisibility listOfResources ->
            ( model |> changePoiResourceVisibility listOfResources |> updateMapPoiData, Cmd.none )

        ChangePoiLocationVisibility listOfLocations ->
            ( model |> changePoiLocationVisibility listOfLocations |> updateMapPoiData, Cmd.none )

        SetPoiVisibility objectType toVisible ->
            ( model |> setPoiVisibility objectType toVisible |> updateMapPoiData, Cmd.none )

        SetFilter filterType ->
            case filterType of
                NamedOnly namedOnly ->
                    let
                        poiFilter =
                            model.poiFilter

                        newPoiFilter =
                            { poiFilter | namedOnly = namedOnly }
                    in
                    ( { model | poiFilter = newPoiFilter } |> updateMapPoiData, Cmd.none )

        ToggleMapLayer mapLayer ->
            let
                newMapLayers =
                    model.mapLayers
                        |> List.map
                            (\layer ->
                                if layer.label == mapLayer.label then
                                    { layer | visible = not layer.visible }

                                else
                                    layer
                            )
            in
            ( { model | mapLayers = newMapLayers }, Cmd.none )


appendCmd : Cmd Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
appendCmd cmd ( model, oldCmd ) =
    let
        newCmd =
            Cmd.batch [ cmd, oldCmd ]
    in
    ( model, newCmd )


updateUrl : Model -> ( Model, Cmd Msg )
updateUrl model =
    let
        x =
            String.join "=" [ "x", Round.round 1 model.mapOffset.x ]

        y =
            String.join "=" [ "y", Round.round 1 model.mapOffset.y ]

        zoom =
            String.join "=" [ "zoom", Round.round 1 model.zoom ]

        newUrl =
            "?" ++ String.join "&" [ x, y, zoom ]
    in
    ( model, pushUrl newUrl )


setPoiVisibility : ObjectType -> Bool -> Model -> Model
setPoiVisibility objectType toVisible model =
    let
        poiVisibility =
            model.poiVisibility

        newPoiVisibility =
            case objectType of
                Resource ->
                    if toVisible then
                        { poiVisibility | resources = defaultPoiVisibility.resources }

                    else
                        { poiVisibility | resources = [] }

                Location ->
                    if toVisible then
                        { poiVisibility | locations = defaultPoiVisibility.locations }

                    else
                        { poiVisibility | locations = [] }

                _ ->
                    -- should not be reached
                    poiVisibility
    in
    { model | poiVisibility = newPoiVisibility }


changePoiResourceVisibility : List Api.Enum.ResourceResource.ResourceResource -> Model -> Model
changePoiResourceVisibility listOfResources model =
    let
        toggleResource resource list =
            if List.member resource list then
                List.Extra.remove resource list

            else
                resource :: list

        poiVisibility =
            model.poiVisibility

        newResources =
            List.foldl toggleResource listOfResources poiVisibility.resources

        newPoiVisibility =
            { poiVisibility | resources = newResources }
    in
    { model | poiVisibility = newPoiVisibility }


changePoiLocationVisibility : List Api.Enum.LocationCategory.LocationCategory -> Model -> Model
changePoiLocationVisibility listOfLocations model =
    let
        toggleLocation location list =
            if List.member location list then
                List.Extra.remove location list

            else
                location :: list

        poiVisibility =
            model.poiVisibility

        newLocations =
            List.foldl toggleLocation listOfLocations poiVisibility.locations

        newPoiVisibility =
            { poiVisibility | locations = newLocations }
    in
    { model | poiVisibility = newPoiVisibility }


applyMouseWheelZoom : Wheel.Event -> Model -> Model
applyMouseWheelZoom event model =
    let
        offset =
            mouseEventToOffset event.mouseEvent

        newCentrepointX =
            (model.svgElementSize.x / 2) - (((model.svgElementSize.x / 2) - offset.x) / 10)

        newCentrepointY =
            (model.svgElementSize.y / 2) - (((model.svgElementSize.y / 2) - offset.y) / 10)

        ( xProp, yProp, newZoom ) =
            if event.deltaY > 0 then
                -- zooming out keeps centre of map as-is
                ( 0.5, 0.5, model.zoom - zoomStep |> clampZoom )

            else
                -- zooming in tries to aim at where the mouse is
                ( newCentrepointX / model.svgElementSize.x
                , newCentrepointY / model.svgElementSize.y
                , model.zoom + zoomStep |> clampZoom
                )
    in
    model |> changeZoom { xProp = xProp, yProp = yProp } newZoom


changeZoom : { xProp : Float, yProp : Float } -> Float -> Model -> Model
changeZoom proportions newZoom model =
    let
        ( viewportWidthX, viewportWidthY ) =
            viewportWidth model.zoom

        centreOfViewX =
            model.mapOffset.x + (viewportWidthX * proportions.xProp)

        centreOfViewY =
            model.mapOffset.y + (viewportWidthY * proportions.yProp)

        desiredViewportSizeX =
            mapXSize / newZoom

        desiredViewportSizeY =
            mapYSize / newZoom

        offsetToLeft =
            desiredViewportSizeX / 2

        offsetToTop =
            desiredViewportSizeY / 2

        newMapOffset =
            clampMapOffset newZoom <|
                { x = centreOfViewX - offsetToLeft
                , y = centreOfViewY - offsetToTop
                }
    in
    { model | zoom = newZoom, mapOffset = newMapOffset }


setMousePosition : Mouse.Event -> Model -> Model
setMousePosition event model =
    { model | mousePosition = mouseEventToOffset event }


calculateNewMapOffset : Mouse.Event -> Model -> Model
calculateNewMapOffset event model =
    case model.dragData of
        NotDragging ->
            -- shouldn't happen
            model

        Dragging dragData ->
            let
                pos =
                    mouseEventToOffset event

                ( movedX, movedY ) =
                    ( dragData.startingMousePos.x - pos.x, dragData.startingMousePos.y - pos.y )

                ( zoomCorrectionX, zoomCorrectionY ) =
                    ( (mapXSize / model.svgElementSize.x) / model.zoom
                    , (mapYSize / model.svgElementSize.y) / model.zoom
                    )

                newMapOffset =
                    clampMapOffset model.zoom <|
                        { x = dragData.startingMapOffset.x + (movedX * zoomCorrectionX)
                        , y = dragData.startingMapOffset.y + (movedY * zoomCorrectionY)
                        }
            in
            { model | mapOffset = newMapOffset }



--- CLAMPING FUNCTIONS {{{


clampZoom : Float -> Float
clampZoom zoom =
    clamp 1 maxZoom zoom


clampMapOffset : Float -> Offset -> Offset
clampMapOffset zoom mapOffset =
    let
        maxX =
            mapXSize - (mapXSize / zoom)

        maxY =
            mapYSize - (mapYSize / zoom)
    in
    { x = clamp 0 maxX <| mapOffset.x
    , y = clamp 0 maxY <| mapOffset.y
    }



--- }}}


updateMapPoiData : Model -> Model
updateMapPoiData model =
    let
        monsters =
            if model.sidePanelTabSelected == Monster then
                filterMonsters model.mapPoiData.monsters model.poiFilter

            else
                []

        npcs =
            if model.sidePanelTabSelected == Npc then
                filterNpcs model.mapPoiData.npcs model.poiFilter

            else
                []

        resources =
            if model.sidePanelTabSelected == Resource then
                List.filter (\r -> List.member r.resource model.poiVisibility.resources) model.mapPoiData.resources

            else
                []

        locations =
            if model.sidePanelTabSelected == Location then
                List.filter (\l -> List.member l.category model.poiVisibility.locations) model.mapPoiData.locations

            else
                []

        newMapPoiData =
            { locations = locations
            , monsters = monsters
            , npcs = npcs
            , resources = resources
            }
    in
    { model | filteredMapPoiData = newMapPoiData }


filterMonsters : List Monster -> PoiFilter -> List Monster
filterMonsters monsters poiFilter =
    let
        maybeNamedOnlyMonsters =
            if poiFilter.namedOnly == True then
                monsters |> List.filter .named

            else
                monsters
    in
    poiFilter.searchText
        |> Maybe.map (\t -> Helpers.StringFilter.filter .name t maybeNamedOnlyMonsters)
        |> Maybe.withDefault maybeNamedOnlyMonsters


filterNpcs : List Npc -> PoiFilter -> List Npc
filterNpcs npcs poiFilter =
    let
        toSearchString npc =
            String.join " " [ npc.name, Maybe.withDefault "" npc.subtitle ]
    in
    poiFilter.searchText
        |> Maybe.map (\t -> Helpers.StringFilter.filter toSearchString t npcs)
        |> Maybe.withDefault npcs


view : Model -> Html Msg
view model =
    div []
        [ topFilter model
        , mapLayersStyle model
        , div [ class "columns" ]
            [ div [ class "column" ] [ svgView model ]
            , div [ class "column is-one-fifth" ] [ Html.Lazy.lazy6 sidePanel model.flags.guildMember model.poiFilter model.sidePanelTabSelected model.poiVisibility model.svgElementSize model.filteredMapPoiData ]
            ]
        ]


mapLayersStyle : Model -> Html Msg
mapLayersStyle model =
    let
        blockOrNone visible =
            if visible then
                "block"

            else
                "none"

        rule layer =
            text <| "[id='" ++ layer.id ++ "'] { display: " ++ blockOrNone layer.visible ++ " }"
    in
    VirtualDom.node "style" [] (List.map rule model.mapLayers)


topFilter : Model -> Html Msg
topFilter model =
    let
        layerClass mapLayer =
            if mapLayer.visible then
                ""

            else
                "has-text-grey-lighter"

        layer mapLayer =
            div
                [ onClick <| ToggleMapLayer mapLayer
                , class <| layerClass mapLayer ++ " is-clickable is-unselectable dropdown-item"
                ]
                [ span [] [ text mapLayer.label ]
                , if mapLayer.visible then
                    span [ class "has-text-success" ]
                        [ i [ class "fas fa-check" ] []
                        ]

                  else
                    text ""
                ]
    in
    div [ class "container mb-5" ]
        [ div [ class "dropdown is-hoverable map-layers-dropdown" ]
            [ div
                [ class "dropdown-trigger" ]
                [ button [ class "button is-info is-light" ]
                    [ span [] [ text "Layers" ]
                    , span [ class "icon" ] [ i [ class "fas fa-angle-down" ] [] ]
                    ]
                ]
            , div [ class "dropdown-menu", id "layer-dropdown-menu" ]
                [ div [ class "dropdown-content" ]
                    (List.map layer model.mapLayers)
                ]
            ]
        ]


sidePanel : Bool -> PoiFilter -> ObjectType -> PoiVisibility -> Offset -> MapPoiData -> Html Msg
sidePanel guildMember poiFilter sidePanelTabSelected poiVisibility svgElementSize mapPoiData =
    let
        activeIf b =
            Helpers.strIf b "is-active"

        allOrNoneBlock objectType =
            div [ class "panel-block buttons is-flex is-justify-content-center mb-0" ]
                [ button
                    [ onClick <| SetPoiVisibility objectType True, class "button mb-0 is-info" ]
                    [ text "All" ]
                , button
                    [ onClick <| SetPoiVisibility objectType False
                    , class "button mb-0 is-info is-outlined is-light"
                    ]
                    [ text "None" ]
                ]

        searchBlock =
            sidePanelSearchBox poiFilter.searchText

        ( stickyContent, content ) =
            case sidePanelTabSelected of
                Npc ->
                    ( [ searchBlock ], npcsPanel mapPoiData.npcs )

                Monster ->
                    ( [ searchBlock, monstersFilterView ], monstersPanel mapPoiData.monsters )

                Resource ->
                    ( [ allOrNoneBlock Resource ], resourcesPanel poiVisibility )

                Location ->
                    ( [ allOrNoneBlock Location ], otherPanel poiVisibility )
    in
    nav [ style "height" (String.fromFloat svgElementSize.y ++ "px"), class "panel is-danger poi-list" ]
        [ div [ class "sticky-top" ]
            [ div [ class "panel-tabs" ]
                [ a
                    [ onClick <| ChangeSidePanelTab Monster
                    , class (activeIf <| sidePanelTabSelected == Monster)
                    ]
                    [ text "Mobs" ]
                , a
                    [ onClick <| ChangeSidePanelTab Npc
                    , class (activeIf <| sidePanelTabSelected == Npc)
                    ]
                    [ text "NPCs" ]
                , if guildMember then
                    a
                        [ onClick <| ChangeSidePanelTab Resource
                        , class (activeIf <| sidePanelTabSelected == Resource)
                        ]
                        [ text "Nodes" ]

                  else
                    text ""
                , a
                    [ onClick <| ChangeSidePanelTab Location
                    , class (activeIf <| sidePanelTabSelected == Location)
                    ]
                    [ text "Other" ]
                ]
            , div [] stickyContent
            ]
        , content
        ]


sidePanelSearchBox : Maybe String -> Html Msg
sidePanelSearchBox searchText =
    div [ class "search-block panel-block" ]
        [ div [ class "control has-icons-left has-icons-right" ]
            [ input
                [ class "input is-primary"
                , type_ "text"
                , placeholder "Search"
                , value (searchText |> Maybe.withDefault "")
                , onInput SetSearchText
                ]
                []
            , span [ class "icon is-left" ] [ i [ class "fas fa-search" ] [] ]
            , case searchText of
                Just _ ->
                    span [ id "clear-search-text", onClick <| SetSearchText "", class "icon is-right" ] [ i [ class "fas fa-circle-xmark" ] [] ]

                Nothing ->
                    text ""
            ]
        ]


monstersFilterView : Html Msg
monstersFilterView =
    div [ class "panel-block" ]
        [ div [ class "control" ]
            [ label [ class "checkbox" ]
                [ input [ onCheck <| \b -> SetFilter (NamedOnly b), type_ "checkbox" ] []
                , text "Named only"
                ]
            ]
        ]


monstersPanel : List Monster -> Html Msg
monstersPanel monsters =
    let
        panelBlock monster =
            a
                [ Mouse.onOver <| PoiHoverEnter SidebarHover (PoiMonster monster)
                , Mouse.onLeave <| PoiHoverLeave
                , onClick <| SetSearchText monster.name
                , class "panel-block"
                ]
                [ text monster.name ]
    in
    div [] <| List.map panelBlock monsters


npcsPanel : List Npc -> Html Msg
npcsPanel npcs =
    let
        panelBlock npc =
            a
                [ Mouse.onOver <| PoiHoverEnter SidebarHover (PoiNpc npc)
                , Mouse.onLeave <| PoiHoverLeave
                , onClick <| SetSearchText npc.name
                , class "panel-block"
                ]
                [ npcDisplayLabel npc ]
    in
    div [] <| List.map panelBlock npcs


resourcesPanel : PoiVisibility -> Html Msg
resourcesPanel poiVisibility =
    let
        miningNodes =
            [ Api.Enum.ResourceResource.Asherite
            , Api.Enum.ResourceResource.Caspilrite
            , Api.Enum.ResourceResource.Padrium
            , Api.Enum.ResourceResource.Tascium
            , Api.Enum.ResourceResource.Slytheril
            , Api.Enum.ResourceResource.Vestium
            ]

        woodCuttingNodes =
            [ Api.Enum.ResourceResource.Apple
            , Api.Enum.ResourceResource.Pine
            , Api.Enum.ResourceResource.Ash
            , Api.Enum.ResourceResource.Oak
            , Api.Enum.ResourceResource.Maple
            , Api.Enum.ResourceResource.Walnut
            ]

        fibreNodes =
            [ Api.Enum.ResourceResource.Jute
            , Api.Enum.ResourceResource.Cotton
            , Api.Enum.ResourceResource.Flax
            ]

        labelIsVisible resources =
            List.any (\r -> List.member r poiVisibility.resources) resources

        panelBlockClass resources =
            Helpers.strIf (not <| labelIsVisible resources) "has-text-grey-lighter"

        indentedPanelBlock resources label =
            a
                [ onClick <| ChangePoiResourceVisibility resources
                , class <| "panel-block " ++ panelBlockClass resources
                , style "padding-left" "32px"
                ]
                [ text label ]

        panelBlock resources label =
            a
                [ onClick <| ChangePoiResourceVisibility resources
                , class <| "panel-block " ++ panelBlockClass resources
                ]
                [ text label ]
    in
    div []
        [ panelBlock miningNodes "Mining"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Asherite ] "Asherite Ore"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Caspilrite ] "Caspilrite Ore"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Padrium ] "Padrium Ore"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Slytheril ] "Slytheril Crystals"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Tascium ] "Tascium Crystals"
        , panelBlock woodCuttingNodes "Woodcutting"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Apple ] "Apple Tree"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Pine ] "Pine Tree"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Ash ] "Ash Tree"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Oak ] "Oak Tree"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Maple ] "Maple Tree"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Walnut ] "Walnut Tree"
        , panelBlock fibreNodes "Plants"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Jute ] "Jute Plant"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Cotton ] "Cotton Plant"
        , indentedPanelBlock [ Api.Enum.ResourceResource.Flax ] "Flax Plant"
        , panelBlock [ Api.Enum.ResourceResource.Vegetable ] "Wild Vegetables"
        , panelBlock [ Api.Enum.ResourceResource.Herb ] "Wild Herbs"
        , panelBlock [ Api.Enum.ResourceResource.Blackberry ] "Blackberry Bush"
        , panelBlock [ Api.Enum.ResourceResource.Gloomberry ] "Gloomberry Bush"
        , panelBlock [ Api.Enum.ResourceResource.Lily ] "Flame/Moon Lilies"
        , panelBlock [ Api.Enum.ResourceResource.WaterReed ] "Water Reeds"
        ]


otherPanel : PoiVisibility -> Html Msg
otherPanel poiVisibility =
    let
        labelIsVisible locations =
            List.any (\r -> List.member r poiVisibility.locations) locations

        panelBlockClass locations =
            Helpers.strIf (not <| labelIsVisible locations) "has-text-grey-lighter"

        panelBlock locations label =
            a
                [ onClick <| ChangePoiLocationVisibility locations
                , class <| "panel-block " ++ panelBlockClass locations
                ]
                [ text label ]
    in
    div []
        [ panelBlock [ Api.Enum.LocationCategory.Bindstone ] "Bindstones"
        , panelBlock [ Api.Enum.LocationCategory.Portal ] "Portals"
        , panelBlock [ Api.Enum.LocationCategory.Landmark ] "Landmarks"
        ]


svgView : Model -> Html Msg
svgView model =
    let
        mouseEvents =
            case model.dragData of
                Dragging _ ->
                    [ Pointer.onUp PointerUp, Pointer.onMove PointerMove, Pointer.onLeave PointerUp ]

                NotDragging ->
                    [ Pointer.onDown PointerDown, Pointer.onMove PointerMove, Wheel.onWheel MouseWheel ]

        ( viewportWidthX, viewportWidthY ) =
            viewportWidth model.zoom

        viewBox =
            String.join " "
                [ String.fromFloat model.mapOffset.x
                , String.fromFloat model.mapOffset.y
                , String.fromFloat viewportWidthX
                , String.fromFloat viewportWidthY
                ]

        zoomSlider =
            input
                [ type_ "range"
                , Html.Attributes.min "1"
                , Html.Attributes.max <| String.fromInt maxZoom
                , step <| String.fromFloat zoomStep
                , onInput ZoomChanged
                , value <| String.fromFloat model.zoom
                ]
                []

        svgImage =
            Svg.image
                [ VirtualDom.attribute "href" "https://cdn.discordapp.com/attachments/1175493372430000218/1210710301767507998/Thronefast_2024-02-14.png?ex=65eb8cd5&is=65d917d5&hm=b5991cb0c52746a90fe644314bd2fdc7d1c4eb85edd96e9339b1c5c31385e9d5&"
                , Svg.Attributes.width <| String.fromInt mapXSize
                , Svg.Attributes.height <| String.fromInt mapYSize
                ]
                []
    in
    div []
        [ poiHoverTooltip model
        , div [ class "map-container" ]
            [ div [ class "overlay-container zoom" ] [ zoomSlider ]
            , svg
                (mouseEvents ++ [ id "svg-container", Svg.Attributes.viewBox viewBox ])
                [ Maps.Test.test
                , Svg.g [ Svg.Attributes.class "loc-grid" ] [ locLineGrid model ]
                , Svg.Lazy.lazy4 svgPois model.poiHover model.mapCalibration model.zoom model.filteredMapPoiData

                --, testLabel
                ]
            ]
        ]


testLabel : Svg Msg
testLabel =
    Svg.g [ Svg.Attributes.transform "translate(1500, 1500)", Svg.Attributes.class "poi-static-label" ]
        [ Svg.filter
            [ Svg.Attributes.id "poi-static-label-filter"
            , Svg.Attributes.x "-0.1"
            , Svg.Attributes.y "-0.2"
            , Svg.Attributes.width "1.2"
            , Svg.Attributes.height "1.4"
            ]
            [ Svg.feFlood [] []
            , Svg.feComposite [ Svg.Attributes.in_ "SourceGraphic" ] []
            ]
        , Svg.text_
            [ Svg.Attributes.class "poi-static-label-text" ]
            [ text "Shaman Starting Area" ]
        ]


locLineGrid : Model -> Svg Msg
locLineGrid model =
    let
        locLineInterval =
            if model.zoom < 6 then
                500

            else
                250

        locLineLocsX =
            rangeFromTo 1000 6000 locLineInterval |> List.map toFloat

        locLineLocsY =
            rangeFromTo 1000 6000 locLineInterval |> List.map toFloat

        locLine x1 y1 x2 y2 =
            Svg.line
                [ Svg.Attributes.x1 <| String.fromFloat x1
                , Svg.Attributes.y1 <| String.fromFloat y1
                , Svg.Attributes.x2 <| String.fromFloat x2
                , Svg.Attributes.y2 <| String.fromFloat y2
                , Svg.Attributes.class "loc-line"
                ]
                []

        locLabel label baseline x y =
            Svg.text_
                [ Svg.Attributes.x <| String.fromFloat x
                , Svg.Attributes.y <| String.fromFloat y
                , Svg.Attributes.class "loc-line-label"
                , Svg.Attributes.alignmentBaseline baseline
                , Svg.Attributes.style <|
                    String.join "" [ "font-size: ", String.fromFloat <| 25 - model.zoom, "px" ]
                ]
                [ text <| String.fromFloat label ]

        verticalLocs =
            locLineLocsX
                |> List.map (\loc_x -> ( loc_x, locsToSvgCoordinates { x = loc_x, y = 0 } model.mapCalibration ))
                |> List.concatMap
                    (\( loc, { x } ) ->
                        [ locLine x 0 x mapYSize
                        , locLabel loc "hanging" (x + 2) (model.mapOffset.y + 2)
                        ]
                    )

        horizontalLocs =
            locLineLocsY
                |> List.map (\loc_y -> ( loc_y, locsToSvgCoordinates { x = 0, y = loc_y } model.mapCalibration ))
                |> List.concatMap
                    (\( loc, { y } ) ->
                        [ locLine 0 y mapXSize y
                        , locLabel loc "auto" (model.mapOffset.x + 2) (y - 2)
                        ]
                    )
    in
    Svg.g [ Svg.Attributes.class "loc-grid" ] (verticalLocs ++ horizontalLocs)


poiHoverTooltip : Model -> Html Msg
poiHoverTooltip model =
    let
        { x, y } =
            model.mousePosition

        classes =
            "overlay-container poi has-text-weight-semibold"

        topStyle =
            style "top" <| String.join "" [ String.fromFloat (y + 5), "px" ]

        leftStyle =
            style "left" <| String.join "" [ String.fromFloat (x + 5), "px" ]
    in
    case model.poiHover of
        Just ( MapHover, PoiNpc npc ) ->
            div [ topStyle, leftStyle, class classes ] [ npcDisplayLabel npc ]

        Just ( MapHover, PoiMonster monster ) ->
            div [ topStyle, leftStyle, class classes ] [ text monster.name ]

        Just ( MapHover, PoiResource resource ) ->
            div [ topStyle, leftStyle, class classes ] [ text resource.name ]

        Just ( MapHover, PoiLocation location ) ->
            div [ topStyle, leftStyle, class classes ] [ text location.name ]

        Just ( SidebarHover, _ ) ->
            text ""

        Nothing ->
            text ""


svgPois : Maybe ( HoverType, Poi ) -> MapCalibration -> Float -> MapPoiData -> Svg Msg
svgPois poiHover mapCalibration zoom mapPoiData =
    let
        enableRadar =
            -- assumes that lists on other tabs are empty, which is ok
            List.length mapPoiData.npcs == 1 || List.length mapPoiData.monsters == 1

        enablePulseFor this =
            case poiHover of
                Just ( SidebarHover, p ) ->
                    p == this

                _ ->
                    False
    in
    Svg.g [] <|
        List.concat
            [ mapPoiData.locations
                |> List.map PoiLocation
                |> List.map (poiMapMarker False enableRadar mapCalibration zoom)
            , mapPoiData.monsters
                |> List.map PoiMonster
                |> List.map (\p -> poiMapMarker (enablePulseFor p) enableRadar mapCalibration zoom p)
            , mapPoiData.npcs
                |> List.map PoiNpc
                |> List.map (\p -> poiMapMarker (enablePulseFor p) enableRadar mapCalibration zoom p)
            , mapPoiData.resources
                |> List.map PoiResource
                |> List.map (poiMapMarker False enableRadar mapCalibration zoom)
            ]


poiMapMarker : Bool -> Bool -> MapCalibration -> Float -> Poi -> Svg Msg
poiMapMarker enablePulse enableRadar mapCalibration zoom poi =
    let
        ( loc_x, loc_y ) =
            case poi of
                PoiResource r ->
                    ( Just r.loc_x, Just r.loc_y )

                PoiMonster m ->
                    ( m.loc_x, m.loc_y )

                PoiNpc n ->
                    ( n.loc_x, n.loc_y )

                PoiLocation l ->
                    ( l.loc_x, l.loc_y )

        mapMarkerClasses =
            [ case poi of
                PoiNpc _ ->
                    "npc"

                PoiMonster monster ->
                    case ( monster.elite, monster.named ) of
                        -- clean this up later :)
                        ( True, True ) ->
                            "monster monster__elite monster__named"

                        ( True, False ) ->
                            "monster monster__elite"

                        ( False, True ) ->
                            "monster monster__named"

                        _ ->
                            "monster"

                PoiResource resource ->
                    "resource resource__" ++ Api.Enum.ResourceResource.toString resource.resource

                PoiLocation location ->
                    "location location__" ++ Api.Enum.LocationCategory.toString location.category
            , if enablePulse && not enableRadar then
                "pulsing"

              else
                ""
            ]

        mapMarkerClass =
            String.join " " mapMarkerClasses

        mapMarkerRadius =
            clamp 1.5 6 <| 8 - zoom

        mapMarkerAttrs =
            [ Svg.Attributes.class mapMarkerClass
            , Svg.Attributes.r (String.fromFloat mapMarkerRadius)
            , onClick <| ClickedPoi poi
            , Mouse.onOver <| PoiHoverEnter MapHover poi
            , Mouse.onLeave <| PoiHoverLeave
            ]

        radarAnimAttrs =
            [ Svg.Attributes.dur "2s", Svg.Attributes.keyTimes "0; 0.2; 1", Svg.Attributes.repeatCount "indefinite" ]

        radarAnimElement locAttrs =
            Svg.circle (locAttrs ++ [ Svg.Attributes.class <| mapMarkerClass ++ " radar" ])
                [ Svg.animate ([ Svg.Attributes.attributeName "r", Svg.Attributes.from "0", Svg.Attributes.to "400", Svg.Attributes.values "0; 300; 300" ] ++ radarAnimAttrs) []
                , Svg.animate ([ Svg.Attributes.attributeName "opacity", Svg.Attributes.from "0.7", Svg.Attributes.to "0", Svg.Attributes.values "0.7; 0; 0" ] ++ radarAnimAttrs) []
                ]

        svgPoiG locAttrs =
            Svg.g []
                [ Svg.circle (mapMarkerAttrs ++ locAttrs) []
                , Helpers.htmlIf (enableRadar == True) <| radarAnimElement locAttrs
                ]
    in
    Helpers.unwrapMaybeLocTuple ( loc_x, loc_y )
        |> Maybe.map (\( x, y ) -> locsToSvgAttrs { x = x, y = y } mapCalibration)
        |> Maybe.map svgPoiG
        |> Maybe.withDefault (text "")


npcDisplayLabel : Npc -> Html Msg
npcDisplayLabel npc =
    case npc.subtitle of
        Just subtitle ->
            span []
                [ text npc.name
                , span [ class "has-text-grey" ] [ text <| " (" ++ subtitle ++ ")" ]
                ]

        Nothing ->
            text npc.name


viewportWidth : Float -> ( Float, Float )
viewportWidth zoom =
    ( mapXSize / zoom, mapYSize / zoom )


locsToSvgCoordinates : Offset -> MapCalibration -> Offset
locsToSvgCoordinates loc mapCalibration =
    { x = (loc.x - mapCalibration.xLeft) * mapCalibration.xScale
    , y = (mapCalibration.yBottom - loc.y) * mapCalibration.yScale
    }


locsToSvgAttrs : Offset -> MapCalibration -> List (Svg.Attribute Msg)
locsToSvgAttrs loc mapCalibration =
    locsToSvgCoordinates { x = loc.x, y = loc.y } mapCalibration
        |> (\{ x, y } ->
                [ Svg.Attributes.cx <| String.fromFloat <| x
                , Svg.Attributes.cy <| String.fromFloat <| y
                ]
           )


mouseEventToOffset : Mouse.Event -> Offset
mouseEventToOffset event =
    let
        ( x, y ) =
            event.offsetPos
    in
    { x = x, y = y }


rangeFromTo : Int -> Int -> Int -> List Int
rangeFromTo from to step =
    List.range 0 ((to - from) // step) |> List.map (\n -> from + (n * step))


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize (\_ _ -> BrowserResized)


port pushUrl : String -> Cmd msg


port preventScrolling : Bool -> Cmd msg

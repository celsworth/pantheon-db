module Maps.Show exposing (main)

import Api.Enum.LocationCategory exposing (LocationCategory(..))
import Api.Enum.ResourceResource exposing (ResourceResource(..))
import Browser
import Browser.Dom
import Browser.Events
import Helpers
import Helpers.StringFilter
import Html exposing (..)
import Html.Attributes exposing (class, id, placeholder, step, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Html.Events.Extra.Mouse as Mouse
import Html.Events.Extra.Wheel as Wheel
import Html.Lazy
import List.Extra
import Query.Common
import Query.Monsters
import Query.Npcs
import Query.Resources
import Svg exposing (Svg, svg)
import Svg.Attributes
import Task
import Types exposing (Monster, Npc, Resource)
import VirtualDom


type alias Flags =
    { graphqlBaseUrl : String }


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
    { -- a list of ResourceResource that are selected as visible in sidebar
      resources : List Api.Enum.ResourceResource.ResourceResource
    , locations : List Api.Enum.LocationCategory.LocationCategory
    }


defaultPoiVisibility : PoiVisibility
defaultPoiVisibility =
    { -- all on by default
      resources = Api.Enum.ResourceResource.list
    , locations = Api.Enum.LocationCategory.list
    }


type alias Model =
    { flags : Flags
    , zoom : Float
    , mapCalibration : MapCalibration
    , mapPageSize : Offset
    , mapOffset : Offset
    , mousePosition : Offset
    , dragData : DragData
    , poiVisibility : PoiVisibility
    , poiHover : Maybe ( Poi, Mouse.Event )
    , npcs : List Npc
    , monsters : List Monster
    , resources : List Resource
    , searchText : Maybe String
    , sidePanelTabSelected : ObjectType
    }


type ObjectType
    = Npc
    | Monster
    | Resource
    | Location


type Poi
    = PoiNpc Npc
    | PoiResource Resource
    | PoiMonster Monster


type DragData
    = NotDragging
    | Dragging { startingMapOffset : Offset, startingMousePos : Offset }


type Msg
    = MouseMove Mouse.Event
    | MouseDown Mouse.Event
    | MouseUp Mouse.Event
    | MouseWheel Wheel.Event
    | ZoomChanged String
    | GotNpcs (Query.Common.Msg Npc)
    | GotMonsters (Query.Common.Msg Monster)
    | GotResources (Query.Common.Msg Resource)
    | BrowserResized
    | GotSvgElement (Result Browser.Dom.Error Browser.Dom.Element)
    | ClickedPoi Poi
    | PoiHoverEnter Poi Mouse.Event
    | PoiHoverLeave Mouse.Event
    | ChangeSidePanelTab ObjectType
    | SearchBoxChanged String
    | ChangePoiResourceVisibility (List Api.Enum.ResourceResource.ResourceResource)
    | ChangePoiLocationVisibility (List Api.Enum.LocationCategory.LocationCategory)
    | SetPoiVisibility ObjectType Bool


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        calibrationInput1 =
            -- tavern keeper
            { loc = { x = 3454.23, y = 3729 }
            , map = { x = 1308.2, y = 1112.1 }
            }

        calibrationInput2 =
            -- oceanside portal
            { loc = { x = 4746.07, y = 2856.59 }
            , map = { x = 3087.02, y = 2316.98 }
            }
    in
    ( { flags = flags
      , zoom = 1
      , mapCalibration = calcMapCalibration calibrationInput1 calibrationInput2
      , mapPageSize = { x = 0, y = 0 }
      , mapOffset = { x = 0, y = 0 }
      , mousePosition = { x = 0, y = 0 }
      , dragData = NotDragging
      , poiVisibility = defaultPoiVisibility
      , poiHover = Nothing
      , npcs = []
      , monsters = []
      , resources = []
      , searchText = Nothing
      , sidePanelTabSelected = Resource
      }
    , Cmd.batch
        [ Query.Npcs.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotNpcs }
        , Query.Monsters.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotMonsters }
        , Query.Resources.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotResources }
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


mouseEventToOffset : Mouse.Event -> Offset
mouseEventToOffset event =
    let
        ( x, y ) =
            event.offsetPos
    in
    { x = x, y = y }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNpcs response ->
            ( { model | npcs = Query.Common.parseList response }, Cmd.none )

        GotMonsters response ->
            ( { model | monsters = Query.Common.parseList response }, Cmd.none )

        GotResources response ->
            ( { model | resources = Query.Common.parseList response }, Cmd.none )

        MouseWheel event ->
            ( model |> applyMouseWheelZoom event, Cmd.none )

        ZoomChanged value ->
            ( model |> changeZoom { xProp = 0.5, yProp = 0.5 } (value |> String.toFloat |> Maybe.withDefault 1)
            , Cmd.none
            )

        MouseMove event ->
            ( model |> calculateNewMapOffset event |> storeMousePosition event, Cmd.none )

        MouseDown event ->
            let
                _ =
                    Debug.log "MouseDown" event
            in
            ( { model
                | dragData =
                    Dragging
                        { startingMapOffset = model.mapOffset
                        , startingMousePos = mouseEventToOffset event
                        }
              }
            , Cmd.none
            )

        MouseUp _ ->
            ( { model | dragData = NotDragging }, Cmd.none )

        BrowserResized ->
            ( model, Browser.Dom.getElement "svg-container" |> Task.attempt GotSvgElement )

        GotSvgElement (Ok element) ->
            let
                newMapPageSize =
                    { x = element.element.width, y = element.element.height }
            in
            ( { model | mapPageSize = newMapPageSize }, Cmd.none )

        GotSvgElement (Err _) ->
            ( model, Cmd.none )

        PoiHoverEnter poi event ->
            ( { model | poiHover = Just ( poi, event ) }, Cmd.none )

        PoiHoverLeave _ ->
            ( { model | poiHover = Nothing }, Cmd.none )

        ClickedPoi target ->
            let
                _ =
                    Debug.log "ClickedPoi" target
            in
            ( model, Cmd.none )

        SearchBoxChanged searchText ->
            let
                maybeSearchText =
                    Helpers.maybeIf (not <| String.isEmpty searchText) searchText
            in
            ( { model | searchText = maybeSearchText }, Cmd.none )

        ChangeSidePanelTab toTab ->
            ( { model | sidePanelTabSelected = toTab }, Cmd.none )

        ChangePoiResourceVisibility listOfResources ->
            ( model |> changePoiResourceVisibility listOfResources, Cmd.none )

        ChangePoiLocationVisibility listOfLocations ->
            ( model |> changePoiLocationVisibility listOfLocations, Cmd.none )

        SetPoiVisibility objectType toVisible ->
            ( model |> setPoiVisibility objectType toVisible, Cmd.none )


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



--- clickPositionToSvgCoordinates (unused) {{{


clickPositionToSvgCoordinates : ( Float, Float ) -> Model -> Offset
clickPositionToSvgCoordinates ( x, y ) model =
    let
        -- this is 0 - model.mapPageSize.x (position in viewbox, not adjusted for offset or zoom)
        -- scale that to a proportion of mapPageSize
        ( x2, y2 ) =
            ( x / model.mapPageSize.x, y / model.mapPageSize.y )

        -- adjust that for zoom
        ( x3, y3 ) =
            ( x2 / model.zoom, y2 / model.zoom )

        -- multiply that out to actual mapSize (2800 x 2080)
        ( x4, y4 ) =
            ( x3 * mapXSize, y3 * mapYSize )

        -- add on mapOffset if any
        ( x5, y5 ) =
            ( x4 + model.mapOffset.x, y4 + model.mapOffset.y )
    in
    { x = x5, y = y5 }



--- }}}


viewportWidth : Model -> ( Float, Float )
viewportWidth model =
    ( mapXSize / model.zoom, mapYSize / model.zoom )


applyMouseWheelZoom : Wheel.Event -> Model -> Model
applyMouseWheelZoom event model =
    let
        offset =
            mouseEventToOffset event.mouseEvent

        newCentrepointX =
            (model.mapPageSize.x / 2) - (((model.mapPageSize.x / 2) - offset.x) / 10)

        newCentrepointY =
            (model.mapPageSize.y / 2) - (((model.mapPageSize.y / 2) - offset.y) / 10)

        ( xProp, yProp, newZoom ) =
            if event.deltaY > 0 then
                -- zooming out keeps centre of map as-is
                ( 0.5, 0.5, model.zoom - 0.2 |> clampZoom )

            else
                -- zooming in tries to aim at where the mouse is
                ( newCentrepointX / model.mapPageSize.x
                , newCentrepointY / model.mapPageSize.y
                , model.zoom + 0.2 |> clampZoom
                )
    in
    model |> changeZoom { xProp = xProp, yProp = yProp } newZoom


changeZoom : { xProp : Float, yProp : Float } -> Float -> Model -> Model
changeZoom proportions newZoom model =
    let
        ( viewportWidthX, viewportWidthY ) =
            viewportWidth model

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


storeMousePosition : Mouse.Event -> Model -> Model
storeMousePosition event model =
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
                    ( (mapXSize / model.mapPageSize.x) / model.zoom
                    , (mapYSize / model.mapPageSize.y) / model.zoom
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
    clamp 1 10 zoom


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


view : Model -> Html Msg
view model =
    let
        monsters =
            if model.sidePanelTabSelected == Monster then
                filterMonsters model.monsters model.searchText

            else
                []

        npcs =
            if model.sidePanelTabSelected == Npc then
                filterNpcs model.npcs model.searchText

            else
                []

        resources =
            if model.sidePanelTabSelected == Resource then
                model.resources
                    |> List.filter (\r -> List.member r.resource model.poiVisibility.resources)

            else
                []
    in
    div [ class "columns" ]
        [ div [ class "column" ] [ svgView model npcs resources monsters ]
        , div [ class "column is-one-fifth" ] [ sidePanel model npcs monsters ]
        ]


filterMonsters : List Monster -> Maybe String -> List Monster
filterMonsters monsters searchText =
    searchText
        |> Maybe.map (\t -> Helpers.StringFilter.filter .name t monsters)
        |> Maybe.withDefault monsters


filterNpcs : List Npc -> Maybe String -> List Npc
filterNpcs npcs searchText =
    let
        toSearchString npc =
            String.join " " [ npc.name, Maybe.withDefault "" npc.subtitle ]
    in
    searchText
        |> Maybe.map (\t -> Helpers.StringFilter.filter toSearchString t npcs)
        |> Maybe.withDefault npcs


sidePanel : Model -> List Npc -> List Monster -> Html Msg
sidePanel model npcs monsters =
    -- TODO: mouseover should highlight the dot?
    -- TODO: click should put the name into searchbox, hence filtering to that one only
    -- TODO: when one npc showing, use radar effect?
    let
        activeIf b =
            Helpers.strIf b "is-active"

        searchBlock =
            div [ class "search-block panel-block" ]
                [ div [ class "control has-icons-left" ]
                    [ input
                        [ class "input is-primary"
                        , type_ "text"
                        , placeholder "Search"
                        , value (model.searchText |> Maybe.withDefault "")
                        , onInput SearchBoxChanged
                        ]
                        []
                    , span [ class "icon is-left" ] [ i [ class "fas fa-search" ] [] ]
                    ]
                ]

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

        ( stickyContent, content ) =
            case model.sidePanelTabSelected of
                Npc ->
                    ( searchBlock, Html.Lazy.lazy npcsPanel npcs )

                Monster ->
                    ( searchBlock, Html.Lazy.lazy monstersPanel monsters )

                Resource ->
                    ( allOrNoneBlock Resource, Html.Lazy.lazy resourcesPanel model )

                Location ->
                    ( allOrNoneBlock Location, Html.Lazy.lazy otherPanel model )
    in
    nav [ style "height" (String.fromFloat model.mapPageSize.y ++ "px"), class "panel is-danger poi-list" ]
        [ div [ class "sticky-top" ]
            [ div [ class "panel-tabs" ]
                [ a
                    [ onClick <| ChangeSidePanelTab Npc
                    , class (activeIf <| model.sidePanelTabSelected == Npc)
                    ]
                    [ text "NPCs" ]
                , a
                    [ onClick <| ChangeSidePanelTab Monster
                    , class (activeIf <| model.sidePanelTabSelected == Monster)
                    ]
                    [ text "Mobs" ]
                , a
                    [ onClick <| ChangeSidePanelTab Resource
                    , class (activeIf <| model.sidePanelTabSelected == Resource)
                    ]
                    [ text "Nodes" ]
                , a
                    [ onClick <| ChangeSidePanelTab Location
                    , class (activeIf <| model.sidePanelTabSelected == Location)
                    ]
                    [ text "Other" ]
                ]
            , stickyContent
            ]
        , content
        ]


monstersPanel : List Monster -> Html Msg
monstersPanel monsters =
    let
        panelBlock monster =
            a [ class "panel-block" ] [ text monster.name ]
    in
    div [] <| List.map panelBlock monsters


npcsPanel : List Npc -> Html Msg
npcsPanel npcs =
    let
        npcPanelBlock npc =
            a [ class "panel-block" ] [ npcDisplayLabel npc ]
    in
    div [] <| List.map npcPanelBlock npcs


resourcesPanel : Model -> Html Msg
resourcesPanel model =
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
            List.any (\r -> List.member r model.poiVisibility.resources) resources

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


otherPanel : Model -> Html Msg
otherPanel model =
    let
        labelIsVisible locations =
            List.any (\r -> List.member r model.poiVisibility.locations) locations

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


svgView : Model -> List Npc -> List Resource -> List Monster -> Html Msg
svgView model npcs resources monsters =
    let
        mouseEvents =
            case model.dragData of
                Dragging _ ->
                    [ Mouse.onUp MouseUp, Mouse.onMove MouseMove, Mouse.onLeave MouseUp ]

                NotDragging ->
                    [ Mouse.onDown MouseDown, Mouse.onMove MouseMove, Wheel.onWheel MouseWheel ]

        ( viewportWidthX, viewportWidthY ) =
            viewportWidth model

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
                , Html.Attributes.max "10"
                , step "0.2"
                , onInput ZoomChanged
                , value <| String.fromFloat model.zoom
                ]
                []

        svgUse =
            Svg.use [ VirtualDom.attribute "href" "" ] []

        svgImage =
            Svg.image
                [ VirtualDom.attribute "href" "https://cdn.discordapp.com/attachments/1175493372430000218/1210710301767507998/Thronefast_2024-02-14.png?ex=65eb8cd5&is=65d917d5&hm=b5991cb0c52746a90fe644314bd2fdc7d1c4eb85edd96e9339b1c5c31385e9d5&"
                , Svg.Attributes.width <| String.fromInt mapXSize
                , Svg.Attributes.height <| String.fromInt mapYSize
                ]
                []

        locLineLocsX =
            [ 3000, 3500, 4000, 4500, 5000, 5500 ]

        locLineLocsY =
            [ 3000, 3500, 4000, 4500, 5000, 5500 ]

        locLine x1 y1 x2 y2 =
            Svg.line
                [ Svg.Attributes.x1 <| String.fromFloat x1
                , Svg.Attributes.y1 <| String.fromFloat y1
                , Svg.Attributes.x2 <| String.fromFloat x2
                , Svg.Attributes.y2 <| String.fromFloat y2
                , Svg.Attributes.class "loc-grid"
                ]
                []

        locLabel label x y =
            Svg.text_
                [ Svg.Attributes.x <| String.fromFloat x
                , Svg.Attributes.y <| String.fromFloat y
                , Svg.Attributes.class "loc-line-label"
                ]
                [ text <| String.fromFloat <| label ]

        verticalLocs =
            locLineLocsX
                |> List.map (\loc_x -> ( loc_x, locsToSvgCoordinates loc_x 0 model ))
                |> List.map
                    (\( loc, ( x, _ ) ) ->
                        [ locLine x 0 x mapYSize
                        , locLabel loc (x + 2) (model.mapOffset.y + 15)
                        ]
                    )
                |> List.concat

        horizontalLocs =
            locLineLocsY
                |> List.map (\loc_y -> ( loc_y, locsToSvgCoordinates 0 loc_y model ))
                |> List.map
                    (\( loc, ( _, y ) ) ->
                        [ locLine 0 y mapXSize y
                        , locLabel loc (model.mapOffset.x + 5) (y - 2)
                        ]
                    )
                |> List.concat
    in
    div []
        [ poiHoverContainer model
        , div [ class "map-container" ]
            [ div [ class "overlay-container zoom" ] [ zoomSlider ]
            , svg
                (mouseEvents ++ [ id "svg-container", Svg.Attributes.viewBox viewBox ])
                ([ [ svgImage ]
                 , svgPois model monsters npcs resources
                 , verticalLocs
                 , horizontalLocs
                 ]
                    |> List.concat
                )
            ]
        ]


poiHoverContainer : Model -> Html Msg
poiHoverContainer model =
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
        Just ( PoiNpc npc, _ ) ->
            div [ topStyle, leftStyle, class classes ] [ npcDisplayLabel npc ]

        Just ( PoiMonster monster, _ ) ->
            div [ topStyle, leftStyle, class classes ] [ text monster.name ]

        Just ( PoiResource resource, _ ) ->
            div [ topStyle, leftStyle, class classes ] [ text resource.name ]

        Nothing ->
            text ""


svgPois : Model -> List Monster -> List Npc -> List Resource -> List (Svg Msg)
svgPois model monsters npcs resources =
    let
        npcRadar =
            List.length npcs == 1
    in
    List.concat
        [ monsters |> List.map PoiMonster |> List.map (poiCircle False model)
        , resources |> List.map PoiResource |> List.map (poiCircle False model)
        , npcs |> List.map PoiNpc |> List.map (poiCircle npcRadar model)
        ]


locsToSvgCoordinates : Float -> Float -> Model -> ( Float, Float )
locsToSvgCoordinates loc_x loc_y model =
    let
        offsetLocX x =
            (x - model.mapCalibration.xLeft) * model.mapCalibration.xScale

        offsetLocY y =
            (model.mapCalibration.yBottom - y) * model.mapCalibration.yScale
    in
    ( offsetLocX loc_x, offsetLocY loc_y )


maybeLocsToMaybeSvgAttrs : Maybe Float -> Maybe Float -> Model -> Maybe (List (Svg.Attribute Msg))
maybeLocsToMaybeSvgAttrs loc_x loc_y model =
    let
        offsetLocX x =
            (x - model.mapCalibration.xLeft) * model.mapCalibration.xScale

        offsetLocY y =
            (model.mapCalibration.yBottom - y) * model.mapCalibration.yScale
    in
    case ( loc_x, loc_y ) of
        ( Just x, Just y ) ->
            Just
                [ Svg.Attributes.cx <| String.fromFloat <| offsetLocX x
                , Svg.Attributes.cy <| String.fromFloat <| offsetLocY y
                ]

        _ ->
            Nothing


poiCircle : Bool -> Model -> Poi -> Svg Msg
poiCircle enableRadar model poi =
    let
        ( loc_x, loc_y ) =
            case poi of
                PoiResource r ->
                    ( Just r.loc_x, Just r.loc_y )

                PoiMonster m ->
                    ( m.loc_x, m.loc_y )

                PoiNpc n ->
                    ( n.loc_x, n.loc_y )

        cssClass =
            case poi of
                PoiNpc _ ->
                    "npc"

                PoiMonster _ ->
                    "monster"

                PoiResource resource ->
                    "resource resource__" ++ Api.Enum.ResourceResource.toString resource.resource

        circleAttrs =
            [ Svg.Attributes.class <| cssClass
            , Svg.Attributes.r (String.fromFloat (13 - model.zoom))
            , onClick <| ClickedPoi poi
            , Mouse.onOver <| PoiHoverEnter poi
            , Mouse.onLeave <| PoiHoverLeave
            ]

        radarAttrs =
            [ Svg.Attributes.class <| cssClass, Svg.Attributes.style "pointer-events: none" ]

        radarAnimCommonAttrs =
            [ Svg.Attributes.dur "2s", Svg.Attributes.keyTimes "0; 0.2; 1", Svg.Attributes.repeatCount "indefinite" ]

        radarAnimElements =
            [ Svg.animate ([ Svg.Attributes.attributeName "r", Svg.Attributes.from "0", Svg.Attributes.to "400", Svg.Attributes.values "0; 400; 400" ] ++ radarAnimCommonAttrs) []
            , Svg.animate ([ Svg.Attributes.attributeName "opacity", Svg.Attributes.from "0.7", Svg.Attributes.to "0", Svg.Attributes.values "0.7; 0; 0" ] ++ radarAnimCommonAttrs) []
            ]

        svgG locAttrs =
            Svg.g []
                [ Svg.circle (circleAttrs ++ locAttrs) []
                , Helpers.htmlIf (enableRadar == True) <| Svg.circle (radarAttrs ++ locAttrs) radarAnimElements
                ]
    in
    maybeLocsToMaybeSvgAttrs loc_x loc_y model
        |> Maybe.map svgG
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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize (\_ _ -> BrowserResized)

module Maps.Show exposing (main)

import Api.Enum.ResourceResource exposing (ResourceResource(..))
import Browser
import Browser.Dom
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (class, id, placeholder, step, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Html.Events.Extra.Mouse as Mouse
import Html.Events.Extra.Wheel as Wheel
import Html.Lazy
import List.Extra
import Query.Npcs
import Query.Resources
import Svg exposing (Svg, svg)
import Svg.Attributes
import Task
import Types exposing (Npc, Resource)


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
    }


defaultPoiVisibility : PoiVisibility
defaultPoiVisibility =
    { -- all resources by default
      resources = Api.Enum.ResourceResource.list
    }


type alias Model =
    { flags : Flags
    , zoom : Float
    , mapCalibration : MapCalibration
    , mapPageSize : Offset
    , mapOffset : Offset
    , dragData : DragData
    , poiVisibility : PoiVisibility
    , npcs : List Npc
    , resources : List Resource
    , searchText : Maybe String
    , sidePanelTabSelected : SidePanelTabSelection
    }


type SidePanelTabSelection
    = SidePanelTabSelectionNpcs
    | SidePanelTabSelectionMobs
    | SidePanelTabSelectionResources


type Poi
    = PoiNpc Npc
    | PoiResource Resource


type DragData
    = NotDragging
    | Dragging { startingMapOffset : Offset, startingMousePos : Offset }


type Msg
    = MouseMove Mouse.Event
    | MouseDown Mouse.Event
    | MouseUp Mouse.Event
    | MouseWheel Wheel.Event
    | ZoomChanged String
    | GotNpcs Query.Npcs.Msg
    | GotResources Query.Resources.Msg
    | BrowserResized
    | GotSvgElement (Result Browser.Dom.Error Browser.Dom.Element)
    | ClickedPoi Poi
    | ChangeSidePanelTab SidePanelTabSelection
    | SearchBoxChanged String
    | ChangePoiResourceVisibility (List Api.Enum.ResourceResource.ResourceResource)


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
      , dragData = NotDragging
      , poiVisibility = defaultPoiVisibility
      , npcs = []
      , resources = []
      , searchText = Nothing
      , sidePanelTabSelected = SidePanelTabSelectionResources
      }
    , Cmd.batch
        [ Query.Npcs.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotNpcs }
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNpcs graphQlResponse ->
            ( { model | npcs = Query.Npcs.parseResponse graphQlResponse }, Cmd.none )

        GotResources graphQlResponse ->
            ( { model | resources = Query.Resources.parseResponse graphQlResponse }, Cmd.none )

        MouseWheel event ->
            let
                ( offsetPosX, offsetPosY ) =
                    event.mouseEvent.offsetPos

                newCentrepointX =
                    (model.mapPageSize.x / 2) - (((model.mapPageSize.x / 2) - offsetPosX) / 10)

                newCentrepointY =
                    (model.mapPageSize.y / 2) - (((model.mapPageSize.y / 2) - offsetPosY) / 10)

                ( xProp, yProp, newZoom ) =
                    if event.deltaY > 0 then
                        -- zooming out keeps centre of map as-is
                        ( 0.5, 0.5, model.zoom - 0.2 |> boundZoom )

                    else
                        -- zooming in tries to aim at where the mouse is
                        ( newCentrepointX / model.mapPageSize.x
                        , newCentrepointY / model.mapPageSize.y
                        , model.zoom + 0.2 |> boundZoom
                        )
            in
            ( model |> changeZoom { xProp = xProp, yProp = yProp } newZoom, Cmd.none )

        ZoomChanged value ->
            ( model |> changeZoom { xProp = 0.5, yProp = 0.5 } (value |> String.toFloat |> Maybe.withDefault 1)
            , Cmd.none
            )

        MouseMove event ->
            ( model |> calculateNewMapOffset event, Cmd.none )

        MouseDown event ->
            let
                ( offsetPosX, offsetPosY ) =
                    event.offsetPos
            in
            ( { model
                | dragData =
                    Dragging
                        { startingMapOffset = model.mapOffset
                        , startingMousePos = { x = offsetPosX, y = offsetPosY }
                        }
              }
            , Cmd.none
            )

        MouseUp _ ->
            ( { model | dragData = NotDragging }, Cmd.none )

        BrowserResized ->
            ( model
            , Browser.Dom.getElement "svg-container" |> Task.attempt GotSvgElement
            )

        GotSvgElement (Ok element) ->
            let
                newMapPageSize =
                    { x = element.element.width, y = element.element.height }
            in
            ( { model | mapPageSize = newMapPageSize }, Cmd.none )

        GotSvgElement (Err _) ->
            ( model, Cmd.none )

        ClickedPoi target ->
            let
                _ =
                    Debug.log "ClickedPoi" target
            in
            ( model, Cmd.none )

        SearchBoxChanged searchText ->
            let
                maybeSearchText =
                    if String.isEmpty searchText then
                        Nothing

                    else
                        Just searchText
            in
            ( { model | searchText = maybeSearchText }, Cmd.none )

        ChangeSidePanelTab toTab ->
            ( { model | sidePanelTabSelected = toTab }, Cmd.none )

        ChangePoiResourceVisibility listOfResources ->
            ( model |> changePoiResourceVisibility listOfResources, Cmd.none )


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
            boundMapOffset newZoom <|
                { x = centreOfViewX - offsetToLeft
                , y = centreOfViewY - offsetToTop
                }
    in
    { model | zoom = newZoom, mapOffset = newMapOffset }


calculateNewMapOffset : Mouse.Event -> Model -> Model
calculateNewMapOffset event model =
    case model.dragData of
        NotDragging ->
            -- shouldn't happen
            model

        Dragging dragData ->
            let
                ( offsetPosX, offsetPosY ) =
                    event.offsetPos

                ( movedX, movedY ) =
                    ( dragData.startingMousePos.x - offsetPosX
                    , dragData.startingMousePos.y - offsetPosY
                    )

                ( zoomCorrectionX, zoomCorrectionY ) =
                    ( (mapXSize / model.mapPageSize.x) / model.zoom
                    , (mapYSize / model.mapPageSize.y) / model.zoom
                    )

                newMapOffset =
                    boundMapOffset model.zoom <|
                        { x = dragData.startingMapOffset.x + (movedX * zoomCorrectionX)
                        , y = dragData.startingMapOffset.y + (movedY * zoomCorrectionY)
                        }
            in
            { model | mapOffset = newMapOffset }



--- BOUNDING FUNCTIONS {{{


boundZoom : Float -> Float
boundZoom zoom =
    if zoom < 1 then
        1

    else if zoom > 10 then
        10

    else
        zoom


boundMapOffset : Float -> Offset -> Offset
boundMapOffset zoom mapOffset =
    let
        maxX =
            mapXSize - (mapXSize / zoom)

        maxY =
            mapYSize - (mapYSize / zoom)

        boundAtMax : Float -> Float -> Float
        boundAtMax max n =
            if n > max then
                max

            else
                n

        boundAtZero : Float -> Float
        boundAtZero n =
            if n < 0 then
                0

            else
                n
    in
    { x = boundAtMax maxX <| boundAtZero <| mapOffset.x
    , y = boundAtMax maxY <| boundAtZero <| mapOffset.y
    }



--- }}}


view : Model -> Html Msg
view model =
    let
        npcs =
            npcsForTabSelection model.npcs model.searchText model.sidePanelTabSelected

        resources =
            resourcesForTabSelection model.resources model.sidePanelTabSelected
                |> List.filter (\r -> List.member r.resource model.poiVisibility.resources)
    in
    div [ class "columns" ]
        [ div [ class "column" ] [ svgView model npcs resources ]
        , div [ class "column is-one-fifth" ] [ sidePanel model npcs ]
        ]


npcsForTabSelection : List Npc -> Maybe String -> SidePanelTabSelection -> List Npc
npcsForTabSelection npcs searchText selection =
    let
        selected =
            selection == SidePanelTabSelectionNpcs

        npcToSearchString npc =
            String.toLower (npc.name ++ " " ++ Maybe.withDefault "" npc.subtitle)

        filter text =
            npcs |> List.filter (\npc -> String.contains text (npcToSearchString npc))
    in
    if selected then
        case searchText of
            Just t ->
                filter (String.toLower t)

            Nothing ->
                npcs

    else
        []


resourcesForTabSelection : List Resource -> SidePanelTabSelection -> List Resource
resourcesForTabSelection resources selection =
    let
        selected =
            selection == SidePanelTabSelectionResources
    in
    if selected then
        resources

    else
        []


sidePanel : Model -> List Npc -> Html Msg
sidePanel model npcs =
    -- TODO: mouseover should highlight the dot?
    -- TODO: click should put the name into searchbox, hence filtering to that one only
    -- TODO: when one npc showing, use radar effect?
    let
        activeIfSelected b =
            if b then
                "is-active"

            else
                ""

        npcsTabClass =
            activeIfSelected <| model.sidePanelTabSelected == SidePanelTabSelectionNpcs

        resourcesTabClass =
            activeIfSelected <| model.sidePanelTabSelected == SidePanelTabSelectionResources

        searchBlock =
            div [ class "search-block panel-block" ]
                [ div [ class "control has-icons-left" ]
                    [ input
                        [ class "input is-primary"
                        , type_ "text"
                        , placeholder "Search"
                        , onInput SearchBoxChanged
                        ]
                        []
                    , span [ class "icon is-left" ] [ i [ class "fas fa-search" ] [] ]
                    ]
                ]
    in
    nav
        [ style "height" (String.fromFloat model.mapPageSize.y ++ "px")
        , class "npc-list panel is-danger"
        ]
        [ div [ class "sticky-top" ]
            [ div [ class "panel-tabs" ]
                [ a
                    [ onClick <| ChangeSidePanelTab SidePanelTabSelectionNpcs
                    , class npcsTabClass
                    ]
                    [ text "NPCs" ]
                , a [ class "has-text-grey-light" ] [ text "Mobs" ]
                , a
                    [ onClick <| ChangeSidePanelTab SidePanelTabSelectionResources
                    , class resourcesTabClass
                    ]
                    [ text "Resources" ]
                ]
            , searchBlock
            ]
        , if model.sidePanelTabSelected == SidePanelTabSelectionNpcs then
            Html.Lazy.lazy npcsPanel npcs

          else if model.sidePanelTabSelected == SidePanelTabSelectionResources then
            Html.Lazy.lazy resourcesPanel model

          else
            text ""
        ]


npcsPanel : List Npc -> Html Msg
npcsPanel npcs =
    let
        npcString npc =
            case npc.subtitle of
                Just subtitle ->
                    span []
                        [ text npc.name
                        , span [ class "has-text-grey" ] [ text <| " (" ++ subtitle ++ ")" ]
                        ]

                Nothing ->
                    text npc.name

        npcPanelBlock npc =
            a [ class "panel-block" ] [ npcString npc ]
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
    in
    div []
        [ a
            [ onClick <| ChangePoiResourceVisibility miningNodes
            , class "panel-block"
            ]
            [ span [] [ text "Mining" ] ]
        , a
            [ onClick <| ChangePoiResourceVisibility woodCuttingNodes
            , class "panel-block"
            ]
            [ span [] [ text "Woodcutting" ] ]
        , a
            [ onClick <| ChangePoiResourceVisibility fibreNodes
            , class "panel-block"
            ]
            [ span [] [ text "Fibres" ] ]
        , a
            [ onClick <| ChangePoiResourceVisibility [ Api.Enum.ResourceResource.Vegetable ]
            , class "panel-block"
            ]
            [ span [] [ text "Wild Vegetables" ] ]
        , a
            [ onClick <| ChangePoiResourceVisibility [ Api.Enum.ResourceResource.Herb ]
            , class "panel-block"
            ]
            [ span [] [ text "Wild Herbs" ] ]
        , a
            [ onClick <| ChangePoiResourceVisibility [ Api.Enum.ResourceResource.Blackberry ]
            , class "panel-block"
            ]
            [ span [] [ text "Blackberry Bush" ] ]
        , a
            [ onClick <| ChangePoiResourceVisibility [ Api.Enum.ResourceResource.Lily ]
            , class "panel-block"
            ]
            [ span [] [ text "Flame/Moon Lilies" ] ]
        , a
            [ onClick <| ChangePoiResourceVisibility [ Api.Enum.ResourceResource.WaterReed ]
            , class "panel-block"
            ]
            [ span [] [ text "Water Reeds" ] ]
        ]


svgView : Model -> List Npc -> List Resource -> Html Msg
svgView model npcs resources =
    let
        mouseEvents =
            case model.dragData of
                Dragging _ ->
                    [ Mouse.onUp MouseUp, Mouse.onMove MouseMove, Mouse.onLeave MouseUp ]

                NotDragging ->
                    [ Wheel.onWheel MouseWheel, Mouse.onDown MouseDown ]

        ( viewportWidthX, viewportWidthY ) =
            viewportWidth model

        viewBox =
            String.fromFloat model.mapOffset.x
                ++ " "
                ++ String.fromFloat model.mapOffset.y
                ++ " "
                ++ String.fromFloat viewportWidthX
                ++ " "
                ++ String.fromFloat viewportWidthY

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

        svgImage =
            Svg.image
                [ Svg.Attributes.xlinkHref "https://cdn.discordapp.com/attachments/1175493372430000218/1210710301767507998/Thronefast_2024-02-14.png?ex=65eb8cd5&is=65d917d5&hm=b5991cb0c52746a90fe644314bd2fdc7d1c4eb85edd96e9339b1c5c31385e9d5&"
                , Svg.Attributes.width <| String.fromInt mapXSize
                , Svg.Attributes.height <| String.fromInt mapYSize
                ]
                []
    in
    div [ class "map-container" ]
        [ div [ class "zoom-container" ] [ zoomSlider ]
        , svg
            (mouseEvents ++ [ id "svg-container", Svg.Attributes.viewBox viewBox ])
            (svgImage :: pois model npcs resources)
        ]


pois : Model -> List Npc -> List Resource -> List (Svg Msg)
pois model npcs resources =
    List.concat
        [ resources |> List.map PoiResource |> List.map (poiCircle model)
        , npcs |> List.map PoiNpc |> List.map (poiCircle model)
        ]


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


poiCircle : Model -> Poi -> Svg Msg
poiCircle model poi =
    let
        ( loc_x, loc_y ) =
            case poi of
                PoiResource r ->
                    ( Just r.loc_x, Just r.loc_y )

                PoiNpc n ->
                    ( n.loc_x, n.loc_y )

        testRadar =
            case poi of
                PoiNpc npc ->
                    if npc.name == "Akola" then
                        True

                    else
                        False

                _ ->
                    False

        testHighlighted =
            case poi of
                PoiNpc npc ->
                    if npc.name == "Elinae Whispertree" then
                        " highlighted"

                    else
                        ""

                _ ->
                    ""

        cssClass =
            case poi of
                PoiNpc _ ->
                    "npc"

                PoiResource resource ->
                    "resource resource__" ++ Api.Enum.ResourceResource.toString resource.resource

        circleAttrs =
            [ Svg.Attributes.class <| cssClass ++ testHighlighted
            , Svg.Attributes.r (String.fromFloat (13 - model.zoom))
            , onClick <| ClickedPoi poi
            ]

        radarAttrs =
            [ Svg.Attributes.class <| cssClass
            , Svg.Attributes.style "pointer-events: none"
            ]

        radarAnimCommonAttrs =
            [ Svg.Attributes.dur "2s", Svg.Attributes.keyTimes "0; 0.2; 1", Svg.Attributes.repeatCount "indefinite" ]

        radarAnimElements =
            [ Svg.animate ([ Svg.Attributes.attributeName "r", Svg.Attributes.from "0", Svg.Attributes.to "400", Svg.Attributes.values "0; 400; 400" ] ++ radarAnimCommonAttrs) []
            , Svg.animate ([ Svg.Attributes.attributeName "opacity", Svg.Attributes.from "0.7", Svg.Attributes.to "0", Svg.Attributes.values "0.7; 0; 0" ] ++ radarAnimCommonAttrs) []
            ]

        svgG locAttrs =
            Svg.g []
                [ Svg.circle (circleAttrs ++ locAttrs) []
                , if testRadar == True then
                    Svg.circle (radarAttrs ++ locAttrs) radarAnimElements

                  else
                    text ""
                ]
    in
    maybeLocsToMaybeSvgAttrs loc_x loc_y model
        |> Maybe.map svgG
        |> Maybe.withDefault (text "")


poiText : Npc -> Model -> Svg Msg
poiText npc model =
    case ( npc.loc_x, npc.loc_y ) of
        ( Just x, Just y ) ->
            let
                offsetLocX =
                    10 + x - 2500

                offsetLocY =
                    5 + 4450 - y
            in
            Svg.text_
                [ Svg.Attributes.x <| String.fromFloat offsetLocX
                , Svg.Attributes.y <| String.fromFloat offsetLocY
                ]
                [ text npc.name ]

        _ ->
            text ""


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize (\_ _ -> BrowserResized)

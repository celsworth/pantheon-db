module Maps.Show exposing (main)

import Browser
import Browser.Dom
import Html exposing (..)
import Html.Attributes exposing (class, id, step, type_, value)
import Html.Events exposing (onClick, onInput)
import Html.Events.Extra.Mouse as Mouse
import Html.Events.Extra.Wheel as Wheel
import Query.Npcs
import Svg exposing (Svg, svg)
import Svg.Attributes
import Task
import Types exposing (Npc)


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


calibrationInput1 =
    -- tavern keeper
    { loc = { x = 3454.23, y = 3729 }
    , map = { x = 1308.2, y = 1112.1 }
    }


calibrationInput2 =
    -- handsome jyss
    { loc = { x = 3822.91, y = 3449.9 }
    , map = { x = 1827.6, y = 1487.3 }
    }


type DragData
    = NotDragging
    | Dragging { startingMapOffset : Offset, startingMousePos : Offset }


type alias Model =
    { flags : Flags
    , zoom : Float
    , mapCalibration : MapCalibration
    , mapPageSize : Offset
    , mapOffset : Offset
    , dragData : DragData
    , npcs : List Npc
    }


type Msg
    = MouseMove Mouse.Event
    | MouseDown Mouse.Event
    | MouseUp Mouse.Event
    | MouseWheel Wheel.Event
    | ZoomChanged String
    | GotNpcs Query.Npcs.Msg
    | GotSvgElement (Result Browser.Dom.Error Browser.Dom.Element)
    | ClickedThing Npc


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        _ =
            Debug.log "calcCalibration" <| calcMapCalibration calibrationInput1 calibrationInput2
    in
    ( { flags = flags
      , zoom = 1
      , mapCalibration = calcMapCalibration calibrationInput1 calibrationInput2
      , mapPageSize = { x = 0, y = 0 }
      , mapOffset = { x = 0, y = 0 }
      , dragData = NotDragging
      , npcs = []
      }
    , Cmd.batch
        [ Query.Npcs.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotNpcs }
        , Browser.Dom.getElement "svg-container" |> Task.attempt GotSvgElement
        ]
    )


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
            let
                npcs =
                    graphQlResponse |> Query.Npcs.parseResponse
            in
            ( { model | npcs = npcs }, Cmd.none )

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
            let
                _ =
                    Debug.log "MouseMove" event
            in
            ( model |> calculateNewMapOffset event, Cmd.none )

        MouseDown event ->
            let
                _ =
                    Debug.log "MouseDown" event

                _ =
                    Debug.log "clickPositionToSvgCoordinates" <| clickPositionToSvgCoordinates event.offsetPos model

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

        GotSvgElement (Ok element) ->
            let
                newMapPageSize =
                    { x = element.element.width, y = element.element.height }
            in
            ( { model | mapPageSize = newMapPageSize }, Cmd.none )

        GotSvgElement (Err _) ->
            ( model, Cmd.none )

        ClickedThing npc ->
            let
                _ =
                    Debug.log "ClickedThing" npc
            in
            ( model, Cmd.none )


clickPositionToSvgCoordinates : ( Float, Float ) -> Model -> Offset
clickPositionToSvgCoordinates ( x, y ) model =
    let
        -- this is 0 - model.mapPageSize.x (position in viewbox, not adjusted for offset or zoom)
        -- adjust that for zoom
        ( x2, y2 ) =
            ( x / model.zoom, y / model.zoom )

        -- scale that to a proportion of mapPageSize
        ( x3, y3 ) =
            ( x2 / model.mapPageSize.x, y2 / model.mapPageSize.y )

        -- multiply that out to actual mapSize (2800 x 2080)
        ( x4, y4 ) =
            ( x3 * mapXSize, y3 * mapYSize )

        -- add on mapOffset if any
        ( x5, y5 ) =
            ( x4 + model.mapOffset.x, y4 + model.mapOffset.y )
    in
    { x = x5, y = y5 }


changeZoom : { xProp : Float, yProp : Float } -> Float -> Model -> Model
changeZoom proportions newZoom model =
    let
        currentViewportWidthX =
            mapXSize / model.zoom

        currentViewportWidthY =
            mapYSize / model.zoom

        centreOfViewX =
            model.mapOffset.x + (currentViewportWidthX * proportions.xProp)

        centreOfViewY =
            model.mapOffset.y + (currentViewportWidthY * proportions.yProp)

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

                newMapOffset =
                    boundMapOffset model.zoom <|
                        { x = dragData.startingMapOffset.x + movedX
                        , y = dragData.startingMapOffset.y + movedY
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
        mouseEvents =
            case model.dragData of
                Dragging _ ->
                    [ Mouse.onUp MouseUp, Mouse.onMove MouseMove, Mouse.onLeave MouseUp ]

                NotDragging ->
                    [ Wheel.onWheel MouseWheel, Mouse.onDown MouseDown ]
    in
    div []
        [ input
            [ type_ "range"
            , Html.Attributes.min "1"
            , Html.Attributes.max "10"
            , step "0.2"
            , onInput ZoomChanged
            , value <| String.fromFloat model.zoom
            ]
            []
        , div [ class "columns" ]
            [ div [ class "column" ] [ div mouseEvents [ svgView model ] ]
            , div [ class "column is-one-fifth" ]
                [ nav [ class "npc-list panel is-primary" ]
                    [ p [ class "panel-heading" ] [ text "Things" ]

                    -- , npcsForPanel model
                    ]
                ]
            ]
        ]


npcsForPanel : Model -> Html Msg
npcsForPanel model =
    let
        npcString npc =
            case npc.subtitle of
                Just subtitle ->
                    npc.name ++ " (" ++ subtitle ++ ")"

                Nothing ->
                    npc.name

        npcPanelBlock : Npc -> Html Msg
        npcPanelBlock npc =
            a [ class "panel-block" ]
                [ text <| npcString npc
                ]
    in
    div [] <| List.map npcPanelBlock model.npcs


svgView : Model -> Html Msg
svgView model =
    let
        zoomedX =
            mapXSize / model.zoom

        zoomedY =
            mapYSize / model.zoom

        viewBox =
            String.fromFloat model.mapOffset.x
                ++ " "
                ++ String.fromFloat model.mapOffset.y
                ++ " "
                ++ String.fromFloat zoomedX
                ++ " "
                ++ String.fromFloat zoomedY
    in
    svg
        [ id "svg-container", Svg.Attributes.viewBox viewBox ]
        (Svg.image
            [ Svg.Attributes.xlinkHref "https://cdn.discordapp.com/attachments/1175493372430000218/1210710301767507998/Thronefast_2024-02-14.png?ex=65eb8cd5&is=65d917d5&hm=b5991cb0c52746a90fe644314bd2fdc7d1c4eb85edd96e9339b1c5c31385e9d5&"
            , Svg.Attributes.width <| String.fromInt mapXSize
            , Svg.Attributes.height <| String.fromInt mapYSize
            ]
            []
            :: pois model
        )


pois : Model -> List (Svg Msg)
pois model =
    model.npcs
        |> List.map
            (\npc ->
                [ npcPoiCircle npc model

                --    , npcPoiText npc model
                ]
            )
        |> List.concat


npcPoiCircle : Npc -> Model -> Svg Msg
npcPoiCircle npc model =
    case ( npc.loc_x, npc.loc_y ) of
        ( Just x, Just y ) ->
            let
                offsetLocX =
                    (x - model.mapCalibration.xLeft) * model.mapCalibration.xScale

                offsetLocY =
                    (model.mapCalibration.yBottom - y) * model.mapCalibration.yScale
            in
            Svg.circle
                [ Svg.Attributes.class "npc"
                , Svg.Attributes.cx <| String.fromFloat offsetLocX
                , Svg.Attributes.cy <| String.fromFloat offsetLocY
                , Svg.Attributes.r "3"
                , onClick <| ClickedThing npc
                ]
                []

        _ ->
            text ""


npcPoiText : Npc -> Model -> Svg Msg
npcPoiText npc model =
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
    Sub.none

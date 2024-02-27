module Maps.Show exposing (main)

import Browser
import Browser.Dom
import Html exposing (..)
import Html.Attributes exposing (class, id, step, type_, value)
import Html.Events exposing (onInput)
import Html.Events.Extra.Mouse as Mouse
import Html.Events.Extra.Wheel as Wheel
import Query.Npcs
import Svg exposing (Svg, svg)
import Svg.Attributes
import Task
import Types exposing (Loc, Npc)



-- dire lord: map x = 480, map y = 297
-- well: map x = 968, map y = 752
-- map X size = 2800
-- map Y size = 2080
-- thronefast top left point = 2500, 4500 (or 4520?)
-- so bottom left is 2500, 2440


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


divXSize =
    1152


divYSize =
    864


mapXSize : number
mapXSize =
    2800


mapYSize : number
mapYSize =
    2080


type DragData
    = NotDragging
    | Dragging { startingMapOffset : Offset, startingMousePos : Offset }


type alias Model =
    { flags : Flags
    , zoom : Float
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
    | GotElement (Result Browser.Dom.Error Browser.Dom.Element)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      , zoom = 1
      , mapPageSize = { x = 0, y = 0 }
      , mapOffset = { x = 0, y = 0 }
      , dragData = NotDragging
      , npcs = []
      }
    , Cmd.batch
        [ Query.Npcs.makeRequest { url = flags.graphqlBaseUrl, toMsg = GotNpcs }
        , Browser.Dom.getElement "svg-container" |> Task.attempt GotElement
        ]
    )


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
                        ( 0.5
                        , 0.5
                        , model.zoom - 0.2 |> boundZoom
                        )

                    else
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

        GotElement (Ok element) ->
            let
                _ =
                    -- TODO window resize should update this
                    Debug.log "GotElement" element

                newMapPageSize =
                    { x = element.element.width, y = element.element.height }
            in
            ( { model | mapPageSize = newMapPageSize }, Cmd.none )

        GotElement (Err _) ->
            ( model, Cmd.none )


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

        newMapOffset1 =
            { x = centreOfViewX - offsetToLeft
            , y = centreOfViewY - offsetToTop
            }

        newMapOffset2 =
            boundMapOffset newZoom newMapOffset1
    in
    { model | zoom = newZoom, mapOffset = newMapOffset2 }


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
        -- entire viewport is eg 1152x864, so use zoom to reduce those
        -- ie zoom of 2 would be showing eg 576x432
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
        [ id "svg-container"
        , Svg.Attributes.viewBox viewBox

        -- , Svg.Attributes.width "1152"
        -- , Svg.Attributes.height "864"
        ]
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
        |> List.map (\npc -> [ poiCircle npc, poiText npc ])
        |> List.concat


poiCircle : Npc -> Svg Msg
poiCircle npc =
    case ( npc.loc_x, npc.loc_y ) of
        ( Just x, Just y ) ->
            let
                offsetLocX =
                    x - 2500

                offsetLocY =
                    4520 - y
            in
            Svg.circle
                [ Svg.Attributes.cx <| String.fromFloat offsetLocX
                , Svg.Attributes.cy <| String.fromFloat offsetLocY
                , Svg.Attributes.r "3"
                , Svg.Attributes.stroke "#000"
                , Svg.Attributes.fill "#CCCC00"
                ]
                []

        _ ->
            text ""


poiText : Npc -> Svg Msg
poiText npc =
    case ( npc.loc_x, npc.loc_y ) of
        ( Just x, Just y ) ->
            let
                offsetLocX =
                    10 + x - 2500

                offsetLocY =
                    5 + 4520 - y
            in
            Svg.text_
                [ Svg.Attributes.x <| String.fromFloat offsetLocX
                , Svg.Attributes.y <| String.fromFloat offsetLocY
                , Svg.Attributes.style "stroke:white; stroke-width:0.6em; fill:black; paint-order:stroke; stroke-linejoin:round"
                ]
                [ text npc.name ]

        _ ->
            text ""


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

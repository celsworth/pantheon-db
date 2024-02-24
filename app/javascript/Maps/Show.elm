module Maps.Show exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events.Extra.Mouse as Mouse
import Svg exposing (..)
import Svg.Attributes


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
    1152


mapYSize : number
mapYSize =
    864


type DragData
    = NotDragging
    | Dragging { startingMapOffset : Offset, startingMousePos : Offset }


type alias Model =
    { flags : Flags
    , zoom : Float
    , mapOffset : Offset
    , dragData : DragData
    }


type Msg
    = MouseMove Mouse.Event
    | MouseDown Mouse.Event
    | MouseUp Mouse.Event


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      , zoom = 2
      , mapOffset = { x = 0, y = 0 }
      , dragData = NotDragging
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMove event ->
            ( calculateNewMapOffset model event, Cmd.none )

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


calculateNewMapOffset : Model -> Mouse.Event -> Model
calculateNewMapOffset model event =
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

                maxX =
                    mapXSize - (mapXSize / model.zoom)

                maxY =
                    mapYSize - (mapYSize / model.zoom)

                newMapOffset =
                    { x = boundAtMax maxX <| boundAtZero <| dragData.startingMapOffset.x + movedX
                    , y = boundAtMax maxY <| boundAtZero <| dragData.startingMapOffset.y + movedY
                    }
            in
            { model | mapOffset = newMapOffset }


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


view : Model -> Html Msg
view model =
    let
        mouseEvents =
            case model.dragData of
                Dragging _ ->
                    [ Mouse.onUp MouseUp, Mouse.onMove MouseMove, Mouse.onLeave MouseUp ]

                NotDragging ->
                    [ Mouse.onDown MouseDown ]
    in
    div
        (class "map-container" :: mouseEvents)
        [ svgTest model ]


svgTest : Model -> Html Msg
svgTest model =
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
        [ Svg.Attributes.class "svg"
        , Svg.Attributes.width <| String.fromInt mapXSize
        , Svg.Attributes.height <| String.fromInt mapYSize
        , Svg.Attributes.viewBox viewBox
        ]
        [ Svg.image
            [ Svg.Attributes.xlinkHref "https://cdn.discordapp.com/attachments/1175493372430000218/1210710301767507998/Thronefast_2024-02-14.png?ex=65eb8cd5&is=65d917d5&hm=b5991cb0c52746a90fe644314bd2fdc7d1c4eb85edd96e9339b1c5c31385e9d5&"
            , Svg.Attributes.width <| String.fromInt mapXSize
            , Svg.Attributes.height <| String.fromInt mapYSize
            ]
            []
        , Svg.circle
            [ Svg.Attributes.cx "365"
            , Svg.Attributes.cy "105"
            , Svg.Attributes.r "3"
            , Svg.Attributes.stroke "#000"
            , Svg.Attributes.fill "#CCCC00"
            ]
            []
        , Svg.text_ [ Svg.Attributes.x "375", Svg.Attributes.y "115", Svg.Attributes.style "stroke:white; stroke-width:0.6em; fill:black; paint-order:stroke; stroke-linejoin:round" ] [ Html.text "Caesium's Island" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

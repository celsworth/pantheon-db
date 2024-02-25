module Maps.Show exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Html.Events.Extra.Mouse as Mouse
import Svg exposing (..)
import Svg.Attributes
import Types exposing (Loc)


locs : List ( String, Loc )
locs =
    [ ( "Rabbit", { x = 3762, z = 555, y = 3070 } )
    , ( "Scavenger", { x = 3455, z = 476, y = 3771 } )
    ]


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
    | ZoomChanged String


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      , zoom = 1
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

        ZoomChanged value ->
            let
                newZoom =
                    value |> String.toFloat |> Maybe.withDefault 1

                currentViewportWidthX =
                    mapXSize / model.zoom

                currentViewportWidthY =
                    mapYSize / model.zoom

                centreOfViewX =
                    model.mapOffset.x + (currentViewportWidthX / 2)

                centreOfViewY =
                    model.mapOffset.y + (currentViewportWidthY / 2)

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
            ( { model | zoom = newZoom, mapOffset = newMapOffset2 }, Cmd.none )


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
                    boundMapOffset model.zoom <|
                        { x = dragData.startingMapOffset.x + movedX
                        , y = dragData.startingMapOffset.y + movedY
                        }
            in
            { model | mapOffset = newMapOffset }


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
                    [ Mouse.onDown MouseDown ]
    in
    div []
        [ input
            [ type_ "range"
            , Html.Attributes.min "1"
            , Html.Attributes.max "10"
            , Html.Attributes.step "0.05"
            , onInput ZoomChanged
            , value <| String.fromFloat model.zoom
            ]
            []
        , div
            (class "section map-container" :: mouseEvents)
            [ svgTest model ]
        ]


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

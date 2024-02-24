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


type alias MousePos =
    ( Float, Float )


type alias Model =
    { flags : Flags
    , zoom : Float
    , offset : Offset
    , mouseIsDown : Bool
    , mouseDownStartPos : MousePos
    , mapOffsetAtDragStart : Offset
    }


type Msg
    = MouseMove Mouse.Event
    | MouseDown Mouse.Event
    | MouseUp Mouse.Event


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      , zoom = 2
      , offset = { x = 0, y = 0 }
      , mouseIsDown = False
      , mouseDownStartPos = ( 0, 0 )
      , mapOffsetAtDragStart = { x = 0, y = 0 }
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMove event ->
            let
                ( offX, offY ) =
                    event.offsetPos

                ( startX, startY ) =
                    model.mouseDownStartPos

                ( movedX, movedY ) =
                    ( startX - offX, startY - offY )

                newMapOffset =
                    { x = model.mapOffsetAtDragStart.x + movedX
                    , y = model.mapOffsetAtDragStart.y + movedY
                    }
            in
            ( { model | offset = newMapOffset }, Cmd.none )

        MouseDown event ->
            let
                newMouseDown =
                    if event.button == Mouse.MainButton then
                        True

                    else
                        model.mouseIsDown
            in
            ( { model
                | mapOffsetAtDragStart = model.offset
                , mouseDownStartPos = event.offsetPos
                , mouseIsDown = newMouseDown
              }
            , Cmd.none
            )

        MouseUp _ ->
            ( { model | mouseIsDown = False }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        mouseEvents =
            if model.mouseIsDown then
                [ Mouse.onUp MouseUp, Mouse.onMove MouseMove, Mouse.onLeave MouseUp ]

            else
                [ Mouse.onDown MouseDown ]
    in
    div
        ([ class "map-container" ] ++ mouseEvents)
        [ --img [ src "https://cdn.discordapp.com/attachments/1175493372430000218/1210710301767507998/Thronefast_2024-02-14.png?ex=65eb8cd5&is=65d917d5&hm=b5991cb0c52746a90fe644314bd2fdc7d1c4eb85edd96e9339b1c5c31385e9d5&" ] []
          svgTest model
        ]


svgTest : Model -> Html Msg
svgTest model =
    let
        -- entire viewport is 1152 864, so use zoom to reduce those
        -- ie zoom of 2 would be showing 576 x 432 px
        zoomedX =
            1152 / model.zoom

        zoomedY =
            864 / model.zoom

        viewBox =
            String.fromFloat model.offset.x
                ++ " "
                ++ String.fromFloat model.offset.y
                ++ " "
                ++ String.fromFloat zoomedX
                ++ " "
                ++ String.fromFloat zoomedY
    in
    svg
        [ Svg.Attributes.class "svg"
        , Svg.Attributes.width "1152px"
        , Svg.Attributes.height "864px"
        , Svg.Attributes.viewBox viewBox
        ]
        [ Svg.image
            [ Svg.Attributes.xlinkHref "https://cdn.discordapp.com/attachments/1175493372430000218/1210710301767507998/Thronefast_2024-02-14.png?ex=65eb8cd5&is=65d917d5&hm=b5991cb0c52746a90fe644314bd2fdc7d1c4eb85edd96e9339b1c5c31385e9d5&"
            , Svg.Attributes.width "1152"
            , Svg.Attributes.height "864"
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

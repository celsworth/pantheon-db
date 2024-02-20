module Main exposing (main)

import Browser
import Html exposing (Html, text)



-- MAIN


type alias Flags =
    { myData : Int }


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { flags : Flags }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text (String.fromInt 1)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

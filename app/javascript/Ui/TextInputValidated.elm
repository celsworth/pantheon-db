module Ui.TextInputValidated exposing
    ( Model
    , init
    , isChecking
    , isEqualValue
    , isInvalid
    , isValid
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


type Validated t
    = Valid t
    | Invalid t
    | Checking t


type alias Model t msg =
    { state : Validated t
    , label : String
    , onChangeMsg : String -> msg
    }


type alias InitArgs t msg =
    { initialValue : t
    , label : String
    , onChangeMsg : String -> msg
    }


init : InitArgs t msg -> Model t msg
init args =
    { state = Invalid args.initialValue
    , label = args.label
    , onChangeMsg = args.onChangeMsg
    }


value : Model t msg -> t
value model =
    case model.state of
        Valid v ->
            v

        Invalid v ->
            v

        Checking v ->
            v


isEqualValue : t -> Model t msg -> Bool
isEqualValue v model =
    v == value model


isValid : Model t msg -> Model t msg
isValid model =
    { model | state = Valid (value model) }


isInvalid : Model t msg -> Model t msg
isInvalid model =
    { model | state = Invalid (value model) }


isChecking : Model t msg -> Model t msg
isChecking model =
    { model | state = Checking (value model) }


view : Model t msg -> Html msg
view model =
    let
        controlView =
            case model.state of
                Valid str ->
                    viewValid model

                Invalid str ->
                    viewInvalid model

                Checking str ->
                    div [] []

        isValidFoo =
            False
    in
    div [ class "field" ]
        [ label [ class "label" ] [ text model.label ]
        , controlView
        ]


viewValid : Model t msg -> Html msg
viewValid model =
    div [ class "control", class "has-icons-right" ]
        [ input
            [ type_ "text", class "input", class "is-success", onInput model.onChangeMsg ] []
        , span [ class "icon is-right" ] [ i [ class "fas fa-check" ] [] ]
        ]


viewInvalid : Model t msg -> Html msg
viewInvalid model =
    div [ class "control", class "has-icons-right" ]
        [ input
            [ type_ "text", class "input", class "is-danger", onInput model.onChangeMsg ] []
        , span [ class "icon is-right" ] [ i [ class "fas fa-xmark" ] [] ]
        ]

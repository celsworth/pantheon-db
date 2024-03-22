module Resource.Create exposing (main)

import Browser
import Helpers.FuzzyFilter exposing (filter)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Parsers.JumpLoc
import Select
import Types exposing (Loc)
import Ui.ZoneSelect



-- MAIN


type alias Flags =
    { }


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
    { flags : Flags
    , resources : List String
    , selected : Maybe String
    , resourceSelectState : Select.State
    , resourceSelectConfig : Select.Config Msg String
    , zoneSelectModel : Ui.ZoneSelect.Model Msg
    , parsedLoc : Maybe Loc
    }


resourceSelectConfig : Select.Config Msg String
resourceSelectConfig =
    Select.newConfig
        { onSelect = OnSelect
        , toLabel = identity
        , filter = filter 1 identity
        , toMsg = SelectMsg
        }
        |> Select.withEmptySearch True
        |> Select.withClear False
        |> Select.withInputAttrs [ class "input" ]


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( zoneSelectModel, zoneCmd ) =
            Ui.ZoneSelect.init { toMsg = ZoneSelectMsg }
    in
    ( { flags = flags
      , resources = resources
      , selected = Nothing
      , resourceSelectState = Select.init "resource"
      , resourceSelectConfig = resourceSelectConfig
      , zoneSelectModel = zoneSelectModel
      , parsedLoc = Nothing
      }
    , Cmd.batch [ zoneCmd, Cmd.none ]
    )



-- UPDATE


type Msg
    = ZoneSelectMsg Ui.ZoneSelect.Msg
    | OnSelect (Maybe String)
    | SelectMsg (Select.Msg String)
    | OnLocChange String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ZoneSelectMsg zoneMsg ->
            let
                ( updated, cmd ) =
                    Ui.ZoneSelect.update zoneMsg model.zoneSelectModel
            in
            ( { model | zoneSelectModel = updated }, cmd )

        OnSelect maybeResource ->
            ( { model | selected = maybeResource }, Cmd.none )

        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update model.resourceSelectConfig subMsg model.resourceSelectState
            in
            ( { model | resourceSelectState = updated }, cmd )

        OnLocChange loc ->
            let
                newLoc =
                    Parsers.JumpLoc.parse loc
            in
            ( { model | parsedLoc = newLoc }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        locClass =
            case model.parsedLoc /= Nothing of
                True ->
                    "is-success"

                False ->
                    "is-danger"

        select =
            Select.view model.resourceSelectConfig
                model.resourceSelectState
                model.resources
                (model.selected |> Maybe.map (\m -> [ m ]) |> Maybe.withDefault [])
    in
    div []
        [ p [ class "title" ] [ text "Create a Resource" ]
        , div [ class "box" ]
            [ div [ class "field" ] [ label [ class "label" ] [ text "Resource" ], select ]
            , Ui.ZoneSelect.view model.zoneSelectModel
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Location" ]
                , input
                    [ type_ "text"
                    , class "input"
                    , class locClass
                    , onInput OnLocChange
                    , placeholder "/jumploc 3453.94 476.00 3770.94 58"
                    ]
                    []
                ]
            , div [ class "field" ]
                [ div [ class "control" ]
                    [ button [ class "button is-link" ] [ text "Create" ]
                    ]
                ]
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Resource List


resources : List String
resources =
    resourceToLargeAndHuge "Apple Tree"
        ++ resourceToLargeAndHuge "Pine Tree"
        ++ resourceToLargeAndHuge "Oak Tree"
        ++ resourceToLargeAndHuge "Ash Tree"
        ++ resourceToLargeAndHuge "Maple Tree"
        ++ resourceToLargeAndHuge "Asherite Ore Deposit"
        ++ resourceToLargeAndHuge "Caspilrite Ore Deposit"
        ++ resourceToLargeAndHuge "Padrium Ore Deposit"
        ++ resourceToLargeAndHuge "Blackberry Bush"
        ++ [ "Natural Garden"
           ]


resourceToLargeAndHuge : String -> List String
resourceToLargeAndHuge resource =
    [ resource, "Large " ++ resource, "Huge " ++ resource ]

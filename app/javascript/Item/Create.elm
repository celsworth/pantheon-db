module Item.Create exposing (main)

import Browser
import Helpers.FuzzyFilter exposing (filter)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Parsers.JumpLoc
import Query.ItemsByName
import Select
import Types exposing (Loc)
import Ui.ZoneSelect
import Helpers



-- MAIN


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



-- MODEL


type RemoteValidated t
    = Valid t
    | Invalid t
    | Debouncing t
    | Checking t


type alias Model =
    { flags : Flags
    , resources : List String
    , selected : Maybe String
    , resourceSelectState : Select.State
    , resourceSelectConfig : Select.Config Msg String
    , zoneSelectModel : Ui.ZoneSelect.Model Msg
    , name : RemoteValidated String
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
            Ui.ZoneSelect.init { url = flags.graphqlBaseUrl, toMsg = ZoneSelectMsg }
    in
    ( { flags = flags
      , resources = []
      , selected = Nothing
      , resourceSelectState = Select.init "resource"
      , resourceSelectConfig = resourceSelectConfig
      , zoneSelectModel = zoneSelectModel
      , name = Invalid ""
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
    | ItemNameChanged String
    | ItemNameChangedAfterDelay String
    | GotItemsByName String Query.ItemsByName.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ZoneSelectMsg zoneMsg ->
            let
                ( updated, cmd ) =
                    Ui.ZoneSelect.update zoneMsg model.zoneSelectModel
            in
            ( { model | zoneSelectModel = updated }, cmd )

        OnSelect maybeItem ->
            ( { model | selected = maybeItem }, Cmd.none )

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

        ItemNameChanged name ->
            ( { model | name = Debouncing name }, Helpers.delayMsg 300 (ItemNameChangedAfterDelay name) )

        ItemNameChangedAfterDelay name ->
            if Debouncing name == model.name then
                ( { model | name = Checking name }
                , Query.ItemsByName.makeRequest { name = Just name }
                    { url = model.flags.graphqlBaseUrl, toMsg = GotItemsByName name }
                )

            else
                ( model, Cmd.none )

        GotItemsByName forName graphQlResponse ->
            let
                -- FIXME would be better to have a case-insensitive exact match server side
                exactMatchFound =
                    graphQlResponse
                        |> Query.ItemsByName.parseResponse
                        |> List.any (\i -> String.toLower i.name == String.toLower forName)

                newName =
                    if exactMatchFound then
                        Invalid forName

                    else
                        Valid forName
            in
            ( { model | name = newName }, Cmd.none )



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

        ( inputClass, controlClass ) =
            case model.name of
                Valid _ ->
                    ( "is-success", "" )

                Invalid _ ->
                    ( "is-danger", "" )

                Debouncing _ ->
                    ( "is-warning", "is-loading" )

                Checking _ ->
                    ( "is-warning", "is-loading" )
    in
    div []
        [ p [ class "title" ] [ text "Create an Item" ]
        , div [ class "box" ]
            [ div [ class "field" ]
                [ label [ class "label" ] [ text "Item Name" ]
                , div [ class "control", class controlClass ]
                    [ input
                        [ type_ "text", class "input", class inputClass, onInput ItemNameChanged ]
                        []
                    ]
                ]
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




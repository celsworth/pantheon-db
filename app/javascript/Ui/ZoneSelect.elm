module Ui.ZoneSelect exposing (Model, Msg, getSelected, init, update, view)

import Helpers.FuzzyFilter exposing (filter)
import Html exposing (..)
import Html.Attributes exposing (class)
import Query.Zones
import Select
import Types exposing (Zone)


type alias Model =
    { args : InitArgs
    , zones : List Zone
    , selected : Maybe Zone
    , selectState : Select.State
    , selectConfig : Select.Config Msg Zone
    }


type Msg
    = OnSelect (Maybe Zone)
    | SelectMsg (Select.Msg Zone)
    | GotZonesList Query.Zones.Msg


type alias InitArgs =
    { url : String
    }


selectConfig : Select.Config Msg Zone
selectConfig =
    Select.newConfig
        { onSelect = OnSelect
        , toLabel = .name
        , filter = filter 1 .name
        , toMsg = SelectMsg
        }
        |> Select.withEmptySearch True
        |> Select.withClear False
        |> Select.withInputAttrs [ class "input" ]


init : InitArgs -> ( Model, Cmd Msg )
init args =
    ( { args = args
      , zones = []
      , selected = Nothing
      , selectState = Select.init "zone"
      , selectConfig = selectConfig
      }
    , Cmd.map GotZonesList (Query.Zones.makeRequest args.url)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnSelect maybeZone ->
            ( { model | selected = maybeZone }, Cmd.none )

        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update model.selectConfig subMsg model.selectState
            in
            ( { model | selectState = updated }, cmd )

        GotZonesList response ->
            let
                newZones =
                    Query.Zones.parseResponse response
            in
            ( { model | zones = newZones }, Cmd.none )


getSelected : Model -> Maybe Zone
getSelected model =
    model.selected


view : Model -> Html Msg
view model =
    let
        select =
            Select.view model.selectConfig
                model.selectState
                model.zones
                (model.selected |> Maybe.map (\m -> [ m ]) |> Maybe.withDefault [])
    in
    div [ class "field" ] [ label [ class "label" ] [ text "Zone" ], select ]

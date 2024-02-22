module Ui.ZoneSelect exposing (Model, Msg, getSelected, init, update, view)

import Helpers.FuzzyFilter exposing (filter)
import Html exposing (..)
import Html.Attributes exposing (class)
import Query.Zones
import Select
import Types.Zone exposing (Zone)


toLabel : Zone -> String
toLabel =
    .name


type alias Model =
    { zones : List Zone
    , selected : Maybe Zone
    , selectState : Select.State
    , selectConfig : Select.Config Msg Zone
    }


type Msg
    = OnSelect (Maybe Zone)
    | SelectMsg (Select.Msg Zone)
    | GotZonesResponse Query.Zones.Msg


selectConfig : Select.Config Msg Zone
selectConfig =
    Select.newConfig
        { onSelect = OnSelect
        , toLabel = toLabel
        , filter = filter 1 toLabel
        , toMsg = SelectMsg
        }
        |> Select.withEmptySearch True
        |> Select.withClear False
        |> Select.withInputAttrs [ class "input" ]


init : ( Model, Cmd Msg )
init =
    ( { zones = []
      , selected = Nothing
      , selectState = Select.init "zone"
      , selectConfig = selectConfig
      }
    , Cmd.map GotZonesResponse Query.Zones.makeRequest
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

        GotZonesResponse response ->
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

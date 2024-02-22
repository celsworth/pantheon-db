module Ui.ZoneSelect exposing (Model, Msg, getSelected, init, update, view)

import Helpers.FuzzyFilter exposing (filter)
import Html exposing (..)
import Html.Attributes exposing (class)
import Query.Zones
import Select
import Types exposing (Zone)


type alias Model msg =
    { args : InitArgs msg
    , zones : List Zone
    , selected : Maybe Zone
    , selectState : Select.State
    , selectConfig : Select.Config Msg Zone
    }


type Msg
    = OnSelect (Maybe Zone)
    | SelectMsg (Select.Msg Zone)
    | GotZonesList Query.Zones.Msg


type alias InitArgs msg =
    { url : String
    , toMsg : Msg -> msg
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


init : InitArgs msg -> ( Model msg, Cmd msg )
init args =
    ( { args = args
      , zones = []
      , selected = Nothing
      , selectState = Select.init "zone"
      , selectConfig = selectConfig
      }
    , Cmd.map args.toMsg <|
        Query.Zones.makeRequest { url = args.url, toMsg = GotZonesList }
    )


update : Msg -> Model msg -> ( Model msg, Cmd msg )
update msg model =
    let
        cmdMap =
            Cmd.map model.args.toMsg
    in
    case msg of
        OnSelect maybeZone ->
            ( { model | selected = maybeZone }, cmdMap Cmd.none )

        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update model.selectConfig subMsg model.selectState
            in
            ( { model | selectState = updated }, cmdMap cmd )

        GotZonesList response ->
            let
                newZones =
                    Query.Zones.parseResponse response
            in
            ( { model | zones = newZones }, cmdMap Cmd.none )


getSelected : Model msg -> Maybe Zone
getSelected =
    .selected


view : Model msg -> Html msg
view model =
    Html.map model.args.toMsg <|
        div [ class "field" ]
            [ label [ class "label" ] [ text "Zone" ]
            , Select.view model.selectConfig
                model.selectState
                model.zones
                (model.selected |> Maybe.map (\m -> [ m ]) |> Maybe.withDefault [])
            ]

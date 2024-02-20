module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Resource exposing (Resource)
import ResourceRequest
import Select
import Simple.Fuzzy



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
    { flags : Flags
    , available : List Resource
    , itemToLabel : Resource -> String
    , selected : List Resource
    , selectState : Select.State
    , selectConfig : Select.Config Msg Resource
    }


selectConfigResource : Select.Config Msg Resource
selectConfigResource =
    Select.newConfig
        { onSelect = OnSelect
        , toLabel = Resource.toLabel
        , filter = filter 2 Resource.toLabel
        , toMsg = SelectMsg
        }
        |> Select.withMenuAttrs [ style "max-height" "10rem" ]
        |> Select.withClearSvgClass "foo"


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { flags = flags
      , available = Resource.resources
      , itemToLabel = Resource.toLabel
      , selected = []
      , selectState = Select.init "resource"
      , selectConfig = selectConfigResource
      }
    , Cmd.map GotResponse ResourceRequest.makeRequest
    )



-- UPDATE


type Msg
    = NoOp
    | GotResponse ResourceRequest.Msg
    | OnSelect (Maybe Resource)
    | OnRemoveItem Resource
    | SelectMsg (Select.Msg Resource)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse a ->
            let
                _ =
                    Debug.log "GotResponse" a
            in
            ( model, Cmd.none )

        OnSelect maybeColor ->
            let
                selected =
                    maybeColor
                        |> Maybe.map (List.singleton >> List.append model.selected)
                        |> Maybe.withDefault []
            in
            ( { model | selected = selected }, Cmd.none )

        OnRemoveItem colorToRemove ->
            let
                selected =
                    List.filter (\curColor -> curColor /= colorToRemove)
                        model.selected
            in
            ( { model | selected = selected }, Cmd.none )

        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update
                        model.selectConfig
                        subMsg
                        model.selectState
            in
            ( { model | selectState = updated }, cmd )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        title =
            "title"

        prompt =
            "prompt"

        currentSelection =
            p
                []
                [ text (String.join ", " <| List.map model.itemToLabel model.selected) ]

        select =
            Select.view
                model.selectConfig
                model.selectState
                model.available
                model.selected
    in
    div [ class "demo-box" ]
        [ h3 [] [ text title ]
        , p
            []
            [ label [] [ text prompt ]
            ]
        , p
            []
            [ select
            ]
        , currentSelection
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MISC


filter : Int -> (a -> String) -> String -> List a -> Maybe (List a)
filter minChars toLabel query items =
    if String.length query < minChars then
        Nothing

    else
        items
            |> Simple.Fuzzy.filter toLabel query
            |> Just

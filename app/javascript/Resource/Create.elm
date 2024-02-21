module Resource.Create exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Resource
import Select
import Simple.Fuzzy



-- MAIN


type alias Flags =
    {}


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
    }


resourceSelectConfigResource : Select.Config Msg String
resourceSelectConfigResource =
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
    ( { flags = flags
      , resources = Resource.resources
      , selected = Nothing
      , resourceSelectState = Select.init "resource"
      , resourceSelectConfig = resourceSelectConfigResource
      }
    , Cmd.map GotResourceResponse Resource.makeRequest
    )



-- UPDATE


type Msg
    = NoOp
    | GotResourceResponse Resource.Msg
    | OnSelect (Maybe String)
    | SelectMsg (Select.Msg String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResourceResponse _ ->
            ( model, Cmd.none )

        OnSelect maybeResource ->
            ( { model | selected = maybeResource }, Cmd.none )

        SelectMsg subMsg ->
            let
                ( updated, cmd ) =
                    Select.update model.resourceSelectConfig subMsg model.resourceSelectState
            in
            ( { model | resourceSelectState = updated }, cmd )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        currentSelection =
            p [] [ text <| Maybe.withDefault "Nothing" model.selected ]

        select =
            Select.view model.resourceSelectConfig
                model.resourceSelectState
                model.resources
                (model.selected |> Maybe.map (\m -> [ m ]) |> Maybe.withDefault [])
    in
    div [ class "container" ]
        [ div [ class "box" ]
            [ div [ class "field" ]
                [ label [ class "label" ] [ text "Resource" ]
                , select
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Location" ]
                , input
                    [ type_ "text"
                    , class "input is-danger" -- is-danger
                    , placeholder "/jumploc 3453.94 476.00 3770.94 58"
                    ]
                    []
                ]
            ]
        , currentSelection
        ]



-- /jumploc 3453.94 476.00 3770.94 58
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

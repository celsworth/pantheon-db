module Query.Zones exposing (Msg, makeRequest, parseResponse)

import Api.Object.Zone as Zone
import Api.Query as Query
import Graphql.Http
import Graphql.Http.GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)
import Types.Zone exposing (Zone)


type alias ListResponse =
    List Zone


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error ListResponse) ListResponse)


query : SelectionSet ListResponse RootQuery
query =
    Query.zones identity
        (SelectionSet.succeed Zone
            |> with Zone.id
            |> with Zone.name
        )


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "http://localhost:3000/graphql"
        --|> Graphql.Http.withHeader "authorization" "Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


parseResponse : Msg -> List Zone
parseResponse msg =
    case msg of
        GotResponse res ->
            case res of
                RemoteData.NotAsked ->
                    []

                RemoteData.Loading ->
                    []

                RemoteData.Success successData ->
                    successData

                RemoteData.Failure _ ->
                    Debug.todo "handle zones loading error!"


errorToString : Graphql.Http.Error parsedData -> String
errorToString errorData =
    case errorData of
        Graphql.Http.GraphqlError _ graphqlErrors ->
            graphqlErrors
                |> List.map graphqlErrorToString
                |> String.join "\n"

        Graphql.Http.HttpError httpError ->
            "Http Error"


graphqlErrorToString : Graphql.Http.GraphqlError.GraphqlError -> String
graphqlErrorToString error =
    error.message

module Query.Resources exposing (Msg, makeRequest, parseResponse)

import Api.Object.Resource as Resource
import Api.Query
import Graphql.Http
import Graphql.Http.GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)
import Types exposing (Resource)


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error (List Resource)) (List Resource))


query : SelectionSet (List Resource) RootQuery
query =
    Api.Query.zones identity
        (SelectionSet.succeed Resource
            |> with Resource.id
            |> with Resource.name
        )


makeRequest : String -> Cmd Msg
makeRequest url =
    query
        |> Graphql.Http.queryRequest url
        --|> Graphql.Http.withHeader "authorization" "Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)


parseResponse : Msg -> List Resource
parseResponse (GotResponse res) =
    case res of
        RemoteData.NotAsked ->
            []

        RemoteData.Loading ->
            []

        RemoteData.Success successData ->
            successData

        RemoteData.Failure err ->
            Debug.todo <| errorToString err


errorToString : Graphql.Http.Error parsedData -> String
errorToString errorData =
    case errorData of
        Graphql.Http.GraphqlError _ graphqlErrors ->
            graphqlErrors
                |> List.map graphqlErrorToString
                |> String.join "\n"

        Graphql.Http.HttpError _ ->
            "Http Error"


graphqlErrorToString : Graphql.Http.GraphqlError.GraphqlError -> String
graphqlErrorToString =
    .message
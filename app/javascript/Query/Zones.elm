module Query.Zones exposing (Msg, makeRequest, parseResponse)

import Api.Object.Zone as Zone
import Api.Query
import Graphql.Http
import Graphql.Http.GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)
import Types exposing (Zone)


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error (List Zone)) (List Zone))


query : SelectionSet (List Zone) RootQuery
query =
    Api.Query.zones identity
        (SelectionSet.succeed Zone
            |> with Zone.id
            |> with Zone.name
        )


type alias MakeRequestArgs msg =
    { toMsg : Msg -> msg
    }


makeRequest : MakeRequestArgs msg -> Cmd msg
makeRequest args =
    query
        |> Graphql.Http.queryRequest "/graphql"
        --|> Graphql.Http.withHeader "authorization" "Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)
        |> Cmd.map args.toMsg


parseResponse : Msg -> List Zone
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

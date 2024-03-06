module Query.Common exposing (Msg(..), makeRequest, parseList)

import Graphql.Http
import Graphql.Http.GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import RemoteData exposing (RemoteData)


type Msg t
    = ListResponse (RemoteData (Graphql.Http.Error (List t)) (List t))


type alias MakeRequestArgs t msg =
    { url : String
    , toMsg : Msg t -> msg
    }


makeRequest : SelectionSet (List t) RootQuery -> MakeRequestArgs t msg -> Cmd msg
makeRequest query args =
    query
        |> Graphql.Http.queryRequest args.url
        --|> Graphql.Http.withHeader "authorization" "Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59"
        |> Graphql.Http.send (RemoteData.fromResult >> ListResponse)
        |> Cmd.map args.toMsg


parseList : Msg t -> List t
parseList (ListResponse res) =
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

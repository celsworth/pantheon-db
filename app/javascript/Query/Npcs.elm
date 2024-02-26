module Query.Npcs exposing (Msg, makeRequest, parseResponse)

import Api.Object.Npc as Npc
import Api.Query
import Graphql.Http
import Graphql.Http.GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)
import Types exposing (Npc)


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error (List Npc)) (List Npc))


query : SelectionSet (List Npc) RootQuery
query =
    Api.Query.npcs identity
        (SelectionSet.succeed Npc
            |> with Npc.id
            |> with Npc.name
            |> with Npc.subtitle
            |> with Npc.locX
            |> with Npc.locY
        )

type alias MakeRequestArgs msg =
    { url : String
    , toMsg : Msg -> msg
    }

makeRequest : MakeRequestArgs msg -> Cmd msg
makeRequest args =
    query
        |> Graphql.Http.queryRequest args.url
        --|> Graphql.Http.withHeader "authorization" "Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)
        |> Cmd.map args.toMsg


parseResponse : Msg -> List Npc
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

module Query.ItemsByName exposing (Msg, makeRequest, parseResponse)

import Api.Object.Item as Item
import Api.Query
import Graphql.Http
import Graphql.Http.GraphqlError
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument as OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)
import Types exposing (Item)


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error (List Item)) (List Item))


type alias QueryArgs =
    { name : Maybe String
    }


query : QueryArgs -> SelectionSet (List Item) RootQuery
query queryArgs =
    let
        args =
            \optionals -> { optionals | name = OptionalArgument.fromMaybe queryArgs.name }
    in
    Api.Query.items args <|
        (SelectionSet.succeed Item
            |> with Item.id
            |> with Item.name
        )


type alias MakeRequestArgs msg =
    { url : String
    , toMsg : Msg -> msg
    }


makeRequest : QueryArgs -> MakeRequestArgs msg -> Cmd msg
makeRequest queryArgs args =
    query queryArgs
        |> Graphql.Http.queryRequest args.url
        --|> Graphql.Http.withHeader "authorization" "Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)
        |> Cmd.map args.toMsg


parseResponse : Msg -> List Item
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

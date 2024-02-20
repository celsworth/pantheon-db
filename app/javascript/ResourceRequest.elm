module ResourceRequest exposing (makeRequest, Msg)

import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import PantheonApi.Object.Resource as Resource
import PantheonApi.Query as Query
import PantheonApi.ScalarCodecs
import RemoteData exposing (RemoteData)


type alias Response =
    List Resource


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error Response) Response)


type alias Resource =
    { id : PantheonApi.ScalarCodecs.Id
    , name : String
    }


query : SelectionSet Response RootQuery
query =
    Query.resources identity
        (SelectionSet.succeed Resource
            |> with Resource.id
            |> with Resource.name
        )


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphql.Http.queryRequest "http://localhost:3000/graphql"
        --|> Graphql.Http.withHeader "authorization" "Bearer dbd4c239b0bbaa40ab0ea291fa811775da8f5b59"
        |> Graphql.Http.send (RemoteData.fromResult >> GotResponse)

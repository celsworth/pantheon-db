module Resource exposing (Resource, Msg, resources, makeRequest)

import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import PantheonApi.Object.Resource as Resource
import PantheonApi.Query as Query
import PantheonApi.ScalarCodecs
import RemoteData exposing (RemoteData)


resources : List String
resources =
    [ "Apple Tree"
    , "Large Apple Tree"
    , "Huge Apple Tree"
    , "Pine Tree"
    , "Large Pine Tree"
    , "Huge Pine Tree"
    , "Oak Tree"
    , "Large Oak Tree"
    , "Huge Oak Tree"
    ]



---
--- GRAPHQL
---


type alias ListResponse =
    List Resource


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error ListResponse) ListResponse)


type alias Resource =
    { id : PantheonApi.ScalarCodecs.Id
    , name : String
    }


query : SelectionSet ListResponse RootQuery
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

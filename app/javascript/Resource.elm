module Resource exposing (Msg, makeRequest, resources)

import Api.Object.Resource as Resource
import Api.Query as Query
import Api.ScalarCodecs
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)


resources : List String
resources =
    resourceToLargeAndHuge "Apple Tree"
        ++ resourceToLargeAndHuge "Pine Tree"
        ++ resourceToLargeAndHuge "Oak Tree"
        ++ resourceToLargeAndHuge "Ash Tree"
        ++ resourceToLargeAndHuge "Maple Tree"
        ++ resourceToLargeAndHuge "Asherite Ore Deposit"
        ++ resourceToLargeAndHuge "Caspilrite Ore Deposit"
        ++ resourceToLargeAndHuge "Padrium Ore Deposit"
        ++ resourceToLargeAndHuge "Blackberry Bush"
        ++ [ "Natural Garden"
           ]


resourceToLargeAndHuge : String -> List String
resourceToLargeAndHuge resource =
    [ resource, "Large " ++ resource, "Huge " ++ resource ]



---
--- GRAPHQL
---


type alias ListResponse =
    List Resource


type Msg
    = GotResponse (RemoteData (Graphql.Http.Error ListResponse) ListResponse)


type alias Resource =
    { id : Api.ScalarCodecs.Id
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

module Query.Resources exposing (makeRequest)

import Api.Object.Resource as Resource
import Api.Query
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Query.Common exposing (Msg(..))
import Types exposing (Resource)


query : SelectionSet (List Resource) RootQuery
query =
    Api.Query.resources identity
        (SelectionSet.succeed Resource
            |> with Resource.id
            |> with Resource.name
            |> with Resource.locX
            |> with Resource.locY
            |> with Resource.resource
        )


type alias MakeRequestArgs msg =
    { url : String
    , toMsg : Msg Resource -> msg
    }


makeRequest : MakeRequestArgs msg -> Cmd msg
makeRequest args =
  Query.Common.makeRequest query args

module Query.Monsters exposing (makeRequest)

import Api.Object.Monster as Monster
import Api.Query
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Query.Common exposing (Msg(..))
import Types exposing (Monster)


query : SelectionSet (List Monster) RootQuery
query =
    Api.Query.monsters identity
        (SelectionSet.succeed Monster
            |> with Monster.id
            |> with Monster.name
            |> with Monster.elite
            |> with Monster.named
            |> with Monster.locX
            |> with Monster.locY
        )


type alias MakeRequestArgs msg =
    { toMsg : Msg Monster -> msg
    }


makeRequest : MakeRequestArgs msg -> Cmd msg
makeRequest args =
    Query.Common.makeRequest query args

module Query.Npcs exposing (makeRequest)

import Api.Object.Npc as Npc
import Api.Query
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Query.Common exposing (Msg(..))
import Types exposing (Npc)


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
    { toMsg : Msg Npc -> msg
    }


makeRequest : MakeRequestArgs msg -> Cmd msg
makeRequest args =
    Query.Common.makeRequest query args

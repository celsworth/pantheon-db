module Query.Locations exposing (makeRequest)

import Api.Object.Location as Location
import Api.Query
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument as OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Query.Common exposing (Msg(..))
import Types exposing (Location)


type alias QueryArgs =
    { hasLocCoords : Maybe Bool
    }


query : QueryArgs -> SelectionSet (List Location) RootQuery
query queryArgs =
    let
        args =
            \optionals ->
                { optionals
                    | hasLocCoords = OptionalArgument.fromMaybe queryArgs.hasLocCoords
                }
    in
    Api.Query.locations args
        (SelectionSet.succeed Location
            |> with Location.id
            |> with Location.name
            |> with Location.category
            |> with Location.locX
            |> with Location.locY
        )


type alias MakeRequestArgs msg =
    { url : String
    , toMsg : Msg Location -> msg
    }


makeRequest : QueryArgs -> MakeRequestArgs msg -> Cmd msg
makeRequest queryArgs args =
    Query.Common.makeRequest (query queryArgs) args

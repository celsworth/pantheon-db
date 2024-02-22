module Types exposing (Loc, Resource, Zone)

import Api.ScalarCodecs

type alias Loc =
    { x : Float
    , y : Float
    , z : Float
    }

-- API Types

type alias Resource =
    { id : Api.ScalarCodecs.Id
    , name : String
    }


type alias Zone =
    { id : Api.ScalarCodecs.Id
    , name : String
    }

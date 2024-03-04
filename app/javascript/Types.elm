module Types exposing (Item, Loc, Npc, Resource, Zone)

import Api.ScalarCodecs


type alias Loc =
    { x : Float
    , y : Float
    , z : Float
    }



-- API Types


type alias Item =
    { id : Api.ScalarCodecs.Id
    , name : String
    }


type alias Npc =
    { id : Api.ScalarCodecs.Id
    , name : String
    , subtitle : Maybe String
    , loc_x : Maybe Float
    , loc_y : Maybe Float
    }


type alias Resource =
    { id : Api.ScalarCodecs.Id
    , name : String
    , loc_x : Float
    , loc_y : Float
    }


type alias Zone =
    { id : Api.ScalarCodecs.Id
    , name : String
    }

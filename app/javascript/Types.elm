module Types exposing (Item, Loc, Location, Monster, Npc, Resource, Zone)

import Api.Enum.LocationCategory
import Api.Enum.ResourceResource
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


type alias Monster =
    { id : Api.ScalarCodecs.Id
    , name : String
    , loc_x : Maybe Float
    , loc_y : Maybe Float
    }


type alias Location =
    { id : Api.ScalarCodecs.Id
    , name : String
    , category : Api.Enum.LocationCategory.LocationCategory
    , loc_x : Maybe Float
    , loc_y : Maybe Float
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
    , resource : Api.Enum.ResourceResource.ResourceResource
    }


type alias Zone =
    { id : Api.ScalarCodecs.Id
    , name : String
    }

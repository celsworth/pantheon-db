module Types exposing (Resource, Zone)

import Api.ScalarCodecs


type alias Resource =
    { id : Api.ScalarCodecs.Id
    , name : String
    }


type alias Zone =
    { id : Api.ScalarCodecs.Id
    , name : String
    }

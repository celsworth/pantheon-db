module Types.Zone exposing (Zone)

import Api.ScalarCodecs

type alias Zone =
    { id : Api.ScalarCodecs.Id
    , name : String
    }

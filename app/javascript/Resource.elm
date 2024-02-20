module Resource exposing (Resource, resources, toLabel)


type alias Resource =
    { label : String
    }


toLabel : Resource -> String
toLabel =
    .label


resources : List Resource
resources =
    List.map (\name -> Resource name) resourcesDB


resourcesDB : List String
resourcesDB =
    [ "Apple Tree"
    , "Pine Tree"
    ]

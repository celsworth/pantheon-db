module Helpers.StringFilter exposing (filter)


filter : (a -> String) -> String -> List a -> List a
filter toLabel query items =
    let
        lowerQuery =
            String.toLower query
    in
    items
        |> List.filter (\item -> String.contains lowerQuery (String.toLower <| toLabel item))

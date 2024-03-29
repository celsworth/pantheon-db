-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Enum.ResourceSize exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ResourceSize
    = Normal
    | Large
    | Huge


list : List ResourceSize
list =
    [ Normal, Large, Huge ]


decoder : Decoder ResourceSize
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "normal" ->
                        Decode.succeed Normal

                    "large" ->
                        Decode.succeed Large

                    "huge" ->
                        Decode.succeed Huge

                    _ ->
                        Decode.fail ("Invalid ResourceSize type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ResourceSize -> String
toString enum____ =
    case enum____ of
        Normal ->
            "normal"

        Large ->
            "large"

        Huge ->
            "huge"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ResourceSize
fromString enumString____ =
    case enumString____ of
        "normal" ->
            Just Normal

        "large" ->
            Just Large

        "huge" ->
            Just Huge

        _ ->
            Nothing

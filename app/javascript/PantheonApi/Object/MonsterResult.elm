-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module PantheonApi.Object.MonsterResult exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import PantheonApi.InputObject
import PantheonApi.Interface
import PantheonApi.Object
import PantheonApi.Scalar
import PantheonApi.ScalarCodecs
import PantheonApi.Union


errors : SelectionSet (List String) PantheonApi.Object.MonsterResult
errors =
    Object.selectionForField "(List String)" "errors" [] (Decode.string |> Decode.list)


monster :
    SelectionSet decodesTo PantheonApi.Object.Monster
    -> SelectionSet (Maybe decodesTo) PantheonApi.Object.MonsterResult
monster object____ =
    Object.selectionForCompositeField "monster" [] object____ (Basics.identity >> Decode.nullable)

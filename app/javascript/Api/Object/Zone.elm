-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Object.Zone exposing (..)

import Api.InputObject
import Api.Interface
import Api.Object
import Api.Scalar
import Api.ScalarCodecs
import Api.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


createdAt : SelectionSet Api.ScalarCodecs.ISO8601DateTime Api.Object.Zone
createdAt =
    Object.selectionForField "ScalarCodecs.ISO8601DateTime" "createdAt" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecISO8601DateTime |> .decoder)


id : SelectionSet Api.ScalarCodecs.Id Api.Object.Zone
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecId |> .decoder)


locations :
    SelectionSet decodesTo Api.Object.Location
    -> SelectionSet (Maybe (List decodesTo)) Api.Object.Zone
locations object____ =
    Object.selectionForCompositeField "locations" [] object____ (Basics.identity >> Decode.list >> Decode.nullable)


{-| Shortcut for locations -> monsters
-}
monsters :
    SelectionSet decodesTo Api.Object.Monster
    -> SelectionSet (Maybe (List decodesTo)) Api.Object.Zone
monsters object____ =
    Object.selectionForCompositeField "monsters" [] object____ (Basics.identity >> Decode.list >> Decode.nullable)


name : SelectionSet String Api.Object.Zone
name =
    Object.selectionForField "String" "name" [] Decode.string


{-| Shortcut for locations -> npcs
-}
npcs :
    SelectionSet decodesTo Api.Object.Npc
    -> SelectionSet (Maybe (List decodesTo)) Api.Object.Zone
npcs object____ =
    Object.selectionForCompositeField "npcs" [] object____ (Basics.identity >> Decode.list >> Decode.nullable)


patch :
    SelectionSet decodesTo Api.Object.Patch
    -> SelectionSet decodesTo Api.Object.Zone
patch object____ =
    Object.selectionForCompositeField "patch" [] object____ Basics.identity


updatedAt : SelectionSet Api.ScalarCodecs.ISO8601DateTime Api.Object.Zone
updatedAt =
    Object.selectionForField "ScalarCodecs.ISO8601DateTime" "updatedAt" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecISO8601DateTime |> .decoder)

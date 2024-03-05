-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Object.Location exposing (..)

import Api.Enum.LocationCategory
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


category : SelectionSet Api.Enum.LocationCategory.LocationCategory Api.Object.Location
category =
    Object.selectionForField "Enum.LocationCategory.LocationCategory" "category" [] Api.Enum.LocationCategory.decoder


createdAt : SelectionSet Api.ScalarCodecs.ISO8601DateTime Api.Object.Location
createdAt =
    Object.selectionForField "ScalarCodecs.ISO8601DateTime" "createdAt" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecISO8601DateTime |> .decoder)


id : SelectionSet Api.ScalarCodecs.Id Api.Object.Location
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecId |> .decoder)


locX : SelectionSet (Maybe Float) Api.Object.Location
locX =
    Object.selectionForField "(Maybe Float)" "locX" [] (Decode.float |> Decode.nullable)


locY : SelectionSet (Maybe Float) Api.Object.Location
locY =
    Object.selectionForField "(Maybe Float)" "locY" [] (Decode.float |> Decode.nullable)


locZ : SelectionSet (Maybe Float) Api.Object.Location
locZ =
    Object.selectionForField "(Maybe Float)" "locZ" [] (Decode.float |> Decode.nullable)


monsters :
    SelectionSet decodesTo Api.Object.Monster
    -> SelectionSet (List decodesTo) Api.Object.Location
monsters object____ =
    Object.selectionForCompositeField "monsters" [] object____ (Basics.identity >> Decode.list)


name : SelectionSet String Api.Object.Location
name =
    Object.selectionForField "String" "name" [] Decode.string


npcs :
    SelectionSet decodesTo Api.Object.Npc
    -> SelectionSet (List decodesTo) Api.Object.Location
npcs object____ =
    Object.selectionForCompositeField "npcs" [] object____ (Basics.identity >> Decode.list)


updatedAt : SelectionSet Api.ScalarCodecs.ISO8601DateTime Api.Object.Location
updatedAt =
    Object.selectionForField "ScalarCodecs.ISO8601DateTime" "updatedAt" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecISO8601DateTime |> .decoder)


zone :
    SelectionSet decodesTo Api.Object.Zone
    -> SelectionSet decodesTo Api.Object.Location
zone object____ =
    Object.selectionForCompositeField "zone" [] object____ Basics.identity

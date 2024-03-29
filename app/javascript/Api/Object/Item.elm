-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Object.Item exposing (..)

import Api.Enum.Class
import Api.Enum.ItemAttr
import Api.Enum.ItemCategory
import Api.Enum.ItemSlot
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


{-| An array of attributes on the item.
-}
attrs : SelectionSet (List Api.Enum.ItemAttr.ItemAttr) Api.Object.Item
attrs =
    Object.selectionForField "(List Enum.ItemAttr.ItemAttr)" "attrs" [] (Api.Enum.ItemAttr.decoder |> Decode.list)


buyPrice : SelectionSet (Maybe Int) Api.Object.Item
buyPrice =
    Object.selectionForField "(Maybe Int)" "buyPrice" [] (Decode.int |> Decode.nullable)


category : SelectionSet (Maybe Api.Enum.ItemCategory.ItemCategory) Api.Object.Item
category =
    Object.selectionForField "(Maybe Enum.ItemCategory.ItemCategory)" "category" [] (Api.Enum.ItemCategory.decoder |> Decode.nullable)


{-| An array of classes that can use the item.
-}
classes : SelectionSet (List Api.Enum.Class.Class) Api.Object.Item
classes =
    Object.selectionForField "(List Enum.Class.Class)" "classes" [] (Api.Enum.Class.decoder |> Decode.list)


createdAt : SelectionSet Api.ScalarCodecs.ISO8601DateTime Api.Object.Item
createdAt =
    Object.selectionForField "ScalarCodecs.ISO8601DateTime" "createdAt" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecISO8601DateTime |> .decoder)


droppedBy :
    SelectionSet decodesTo Api.Object.Monster
    -> SelectionSet (List decodesTo) Api.Object.Item
droppedBy object____ =
    Object.selectionForCompositeField "droppedBy" [] object____ (Basics.identity >> Decode.list)


id : SelectionSet Api.ScalarCodecs.Id Api.Object.Item
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecId |> .decoder)


images :
    SelectionSet decodesTo Api.Object.Image
    -> SelectionSet (List decodesTo) Api.Object.Item
images object____ =
    Object.selectionForCompositeField "images" [] object____ (Basics.identity >> Decode.list)


name : SelectionSet String Api.Object.Item
name =
    Object.selectionForField "String" "name" [] Decode.string


patch :
    SelectionSet decodesTo Api.Object.Patch
    -> SelectionSet decodesTo Api.Object.Item
patch object____ =
    Object.selectionForCompositeField "patch" [] object____ Basics.identity


questObjectives :
    SelectionSet decodesTo Api.Object.QuestObjective
    -> SelectionSet (List decodesTo) Api.Object.Item
questObjectives object____ =
    Object.selectionForCompositeField "questObjectives" [] object____ (Basics.identity >> Decode.list)


{-| An array of Quests this Item is listed as an objective for.
-}
requiredForQuests :
    SelectionSet decodesTo Api.Object.Quest
    -> SelectionSet (List decodesTo) Api.Object.Item
requiredForQuests object____ =
    Object.selectionForCompositeField "requiredForQuests" [] object____ (Basics.identity >> Decode.list)


requiredLevel : SelectionSet (Maybe Int) Api.Object.Item
requiredLevel =
    Object.selectionForField "(Maybe Int)" "requiredLevel" [] (Decode.int |> Decode.nullable)


rewardedFromQuests :
    SelectionSet decodesTo Api.Object.Quest
    -> SelectionSet (List decodesTo) Api.Object.Item
rewardedFromQuests object____ =
    Object.selectionForCompositeField "rewardedFromQuests" [] object____ (Basics.identity >> Decode.list)


sellPrice : SelectionSet (Maybe Int) Api.Object.Item
sellPrice =
    Object.selectionForField "(Maybe Int)" "sellPrice" [] (Decode.int |> Decode.nullable)


slot : SelectionSet (Maybe Api.Enum.ItemSlot.ItemSlot) Api.Object.Item
slot =
    Object.selectionForField "(Maybe Enum.ItemSlot.ItemSlot)" "slot" [] (Api.Enum.ItemSlot.decoder |> Decode.nullable)


startsQuest :
    SelectionSet decodesTo Api.Object.Quest
    -> SelectionSet (Maybe decodesTo) Api.Object.Item
startsQuest object____ =
    Object.selectionForCompositeField "startsQuest" [] object____ (Basics.identity >> Decode.nullable)


stats :
    SelectionSet decodesTo Api.Object.ItemStats
    -> SelectionSet (Maybe decodesTo) Api.Object.Item
stats object____ =
    Object.selectionForCompositeField "stats" [] object____ (Basics.identity >> Decode.nullable)


updatedAt : SelectionSet Api.ScalarCodecs.ISO8601DateTime Api.Object.Item
updatedAt =
    Object.selectionForField "ScalarCodecs.ISO8601DateTime" "updatedAt" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecISO8601DateTime |> .decoder)


weight : SelectionSet Float Api.Object.Item
weight =
    Object.selectionForField "Float" "weight" [] Decode.float

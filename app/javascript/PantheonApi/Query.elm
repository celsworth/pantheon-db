-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module PantheonApi.Query exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import PantheonApi.InputObject
import PantheonApi.Interface
import PantheonApi.Object
import PantheonApi.Scalar
import PantheonApi.ScalarCodecs
import PantheonApi.Union


type alias DungeonsOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id
    , name : OptionalArgument String
    }


{-|

  - id - Filter to the given Dungeon ID
  - name - Filter to matching Dungeon names

-}
dungeons :
    (DungeonsOptionalArguments -> DungeonsOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.Dungeon
    -> SelectionSet (List decodesTo) RootQuery
dungeons fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent, name = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "name" filledInOptionals____.name Encode.string ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "dungeons" optionalArgs____ object____ (Basics.identity >> Decode.list)


type alias ItemsOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id
    , name : OptionalArgument String
    , category : OptionalArgument String
    , slot : OptionalArgument String
    , class : OptionalArgument String
    , droppedBy : OptionalArgument PantheonApi.ScalarCodecs.Id
    , startsQuest : OptionalArgument PantheonApi.ScalarCodecs.Id
    , rewardFromQuest : OptionalArgument PantheonApi.ScalarCodecs.Id
    , stats : OptionalArgument (List PantheonApi.InputObject.StatInputFilter)
    , requiredLevel : OptionalArgument (List PantheonApi.InputObject.FloatOperatorInputFilter)
    , weight : OptionalArgument (List PantheonApi.InputObject.FloatOperatorInputFilter)
    }


items :
    (ItemsOptionalArguments -> ItemsOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.Item
    -> SelectionSet (List decodesTo) RootQuery
items fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent, name = Absent, category = Absent, slot = Absent, class = Absent, droppedBy = Absent, startsQuest = Absent, rewardFromQuest = Absent, stats = Absent, requiredLevel = Absent, weight = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "name" filledInOptionals____.name Encode.string, Argument.optional "category" filledInOptionals____.category Encode.string, Argument.optional "slot" filledInOptionals____.slot Encode.string, Argument.optional "class" filledInOptionals____.class Encode.string, Argument.optional "droppedBy" filledInOptionals____.droppedBy (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "startsQuest" filledInOptionals____.startsQuest (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "rewardFromQuest" filledInOptionals____.rewardFromQuest (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "stats" filledInOptionals____.stats (PantheonApi.InputObject.encodeStatInputFilter |> Encode.list), Argument.optional "requiredLevel" filledInOptionals____.requiredLevel (PantheonApi.InputObject.encodeFloatOperatorInputFilter |> Encode.list), Argument.optional "weight" filledInOptionals____.weight (PantheonApi.InputObject.encodeFloatOperatorInputFilter |> Encode.list) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "items" optionalArgs____ object____ (Basics.identity >> Decode.list)


locations :
    SelectionSet decodesTo PantheonApi.Object.Location
    -> SelectionSet (List decodesTo) RootQuery
locations object____ =
    Object.selectionForCompositeField "locations" [] object____ (Basics.identity >> Decode.list)


type alias MonstersOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id
    , name : OptionalArgument String
    , elite : OptionalArgument Bool
    , named : OptionalArgument Bool
    , drops : OptionalArgument PantheonApi.ScalarCodecs.Id
    , locationId : OptionalArgument PantheonApi.ScalarCodecs.Id
    , zoneId : OptionalArgument PantheonApi.ScalarCodecs.Id
    , level : OptionalArgument (List PantheonApi.InputObject.FloatOperatorInputFilter)
    }


{-|

  - drops - Item ID of something the monster drops
  - locationId - Location ID the monster must be in
  - zoneId - Zone ID the monster must be in

-}
monsters :
    (MonstersOptionalArguments -> MonstersOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.Monster
    -> SelectionSet (List decodesTo) RootQuery
monsters fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent, name = Absent, elite = Absent, named = Absent, drops = Absent, locationId = Absent, zoneId = Absent, level = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "name" filledInOptionals____.name Encode.string, Argument.optional "elite" filledInOptionals____.elite Encode.bool, Argument.optional "named" filledInOptionals____.named Encode.bool, Argument.optional "drops" filledInOptionals____.drops (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "locationId" filledInOptionals____.locationId (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "zoneId" filledInOptionals____.zoneId (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "level" filledInOptionals____.level (PantheonApi.InputObject.encodeFloatOperatorInputFilter |> Encode.list) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "monsters" optionalArgs____ object____ (Basics.identity >> Decode.list)


type alias NpcsOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id
    , name : OptionalArgument String
    , subtitle : OptionalArgument String
    , vendor : OptionalArgument Bool
    , locationId : OptionalArgument PantheonApi.ScalarCodecs.Id
    , zoneId : OptionalArgument PantheonApi.ScalarCodecs.Id
    , givesQuest : OptionalArgument PantheonApi.ScalarCodecs.Id
    , receivesQuest : OptionalArgument PantheonApi.ScalarCodecs.Id
    , sellsItem : OptionalArgument PantheonApi.ScalarCodecs.Id
    }


{-|

  - locationId - Location ID the Npc must be in

-}
npcs :
    (NpcsOptionalArguments -> NpcsOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.Npc
    -> SelectionSet (List decodesTo) RootQuery
npcs fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent, name = Absent, subtitle = Absent, vendor = Absent, locationId = Absent, zoneId = Absent, givesQuest = Absent, receivesQuest = Absent, sellsItem = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "name" filledInOptionals____.name Encode.string, Argument.optional "subtitle" filledInOptionals____.subtitle Encode.string, Argument.optional "vendor" filledInOptionals____.vendor Encode.bool, Argument.optional "locationId" filledInOptionals____.locationId (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "zoneId" filledInOptionals____.zoneId (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "givesQuest" filledInOptionals____.givesQuest (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "receivesQuest" filledInOptionals____.receivesQuest (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "sellsItem" filledInOptionals____.sellsItem (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "npcs" optionalArgs____ object____ (Basics.identity >> Decode.list)


type alias QuestObjectivesOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id }


questObjectives :
    (QuestObjectivesOptionalArguments -> QuestObjectivesOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.QuestObjective
    -> SelectionSet (List decodesTo) RootQuery
questObjectives fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "questObjectives" optionalArgs____ object____ (Basics.identity >> Decode.list)


type alias QuestRewardsOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id }


questRewards :
    (QuestRewardsOptionalArguments -> QuestRewardsOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.QuestReward
    -> SelectionSet (List decodesTo) RootQuery
questRewards fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "questRewards" optionalArgs____ object____ (Basics.identity >> Decode.list)


type alias QuestsOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id }


quests :
    (QuestsOptionalArguments -> QuestsOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.Quest
    -> SelectionSet (List decodesTo) RootQuery
quests fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId) ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "quests" optionalArgs____ object____ (Basics.identity >> Decode.list)


type alias ResourcesOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id
    , name : OptionalArgument String
    }


{-|

  - id - Filter to the given Resource ID
  - name - Filter to matching Resource names

-}
resources :
    (ResourcesOptionalArguments -> ResourcesOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.Resource
    -> SelectionSet (List decodesTo) RootQuery
resources fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent, name = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "name" filledInOptionals____.name Encode.string ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "resources" optionalArgs____ object____ (Basics.identity >> Decode.list)


type alias SettlementsOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id
    , name : OptionalArgument String
    }


{-|

  - name - Filter to matching Settlement names

-}
settlements :
    (SettlementsOptionalArguments -> SettlementsOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.Settlement
    -> SelectionSet (List decodesTo) RootQuery
settlements fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent, name = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "name" filledInOptionals____.name Encode.string ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "settlements" optionalArgs____ object____ (Basics.identity >> Decode.list)


type alias ZonesOptionalArguments =
    { id : OptionalArgument PantheonApi.ScalarCodecs.Id
    , name : OptionalArgument String
    }


{-|

  - id - Filter to the given Zone ID
  - name - Filter to matching Zone names

-}
zones :
    (ZonesOptionalArguments -> ZonesOptionalArguments)
    -> SelectionSet decodesTo PantheonApi.Object.Zone
    -> SelectionSet (List decodesTo) RootQuery
zones fillInOptionals____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { id = Absent, name = Absent }

        optionalArgs____ =
            [ Argument.optional "id" filledInOptionals____.id (PantheonApi.ScalarCodecs.codecs |> PantheonApi.Scalar.unwrapEncoder .codecId), Argument.optional "name" filledInOptionals____.name Encode.string ]
                |> List.filterMap Basics.identity
    in
    Object.selectionForCompositeField "zones" optionalArgs____ object____ (Basics.identity >> Decode.list)

-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Enum.ItemCategory exposing (..)

import Json.Decode as Decode exposing (Decoder)


type ItemCategory
    = General
    | Schematic
    | Container
    | Clickie
    | Scroll
    | Potion
    | Ingredient
    | Food
    | Drink
    | Shield
    | Held
    | Jewellery
    | Relic
    | Catalyst
    | Component
    | Material
    | Reagent
    | Resource
    | ClothArmor
    | LeatherArmor
    | ChainArmor
    | PlateArmor
    | BladeWeapon
    | CrushingWeapon
    | DaggerWeapon
    | H2hWeapon
    | StaveWeapon
    | SpearWeapon


list : List ItemCategory
list =
    [ General, Schematic, Container, Clickie, Scroll, Potion, Ingredient, Food, Drink, Shield, Held, Jewellery, Relic, Catalyst, Component, Material, Reagent, Resource, ClothArmor, LeatherArmor, ChainArmor, PlateArmor, BladeWeapon, CrushingWeapon, DaggerWeapon, H2hWeapon, StaveWeapon, SpearWeapon ]


decoder : Decoder ItemCategory
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "general" ->
                        Decode.succeed General

                    "schematic" ->
                        Decode.succeed Schematic

                    "container" ->
                        Decode.succeed Container

                    "clickie" ->
                        Decode.succeed Clickie

                    "scroll" ->
                        Decode.succeed Scroll

                    "potion" ->
                        Decode.succeed Potion

                    "ingredient" ->
                        Decode.succeed Ingredient

                    "food" ->
                        Decode.succeed Food

                    "drink" ->
                        Decode.succeed Drink

                    "shield" ->
                        Decode.succeed Shield

                    "held" ->
                        Decode.succeed Held

                    "jewellery" ->
                        Decode.succeed Jewellery

                    "relic" ->
                        Decode.succeed Relic

                    "catalyst" ->
                        Decode.succeed Catalyst

                    "component" ->
                        Decode.succeed Component

                    "material" ->
                        Decode.succeed Material

                    "reagent" ->
                        Decode.succeed Reagent

                    "resource" ->
                        Decode.succeed Resource

                    "clothArmor" ->
                        Decode.succeed ClothArmor

                    "leatherArmor" ->
                        Decode.succeed LeatherArmor

                    "chainArmor" ->
                        Decode.succeed ChainArmor

                    "plateArmor" ->
                        Decode.succeed PlateArmor

                    "bladeWeapon" ->
                        Decode.succeed BladeWeapon

                    "crushingWeapon" ->
                        Decode.succeed CrushingWeapon

                    "daggerWeapon" ->
                        Decode.succeed DaggerWeapon

                    "h2hWeapon" ->
                        Decode.succeed H2hWeapon

                    "staveWeapon" ->
                        Decode.succeed StaveWeapon

                    "spearWeapon" ->
                        Decode.succeed SpearWeapon

                    _ ->
                        Decode.fail ("Invalid ItemCategory type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representing the Enum to a string that the GraphQL server will recognize.
-}
toString : ItemCategory -> String
toString enum____ =
    case enum____ of
        General ->
            "general"

        Schematic ->
            "schematic"

        Container ->
            "container"

        Clickie ->
            "clickie"

        Scroll ->
            "scroll"

        Potion ->
            "potion"

        Ingredient ->
            "ingredient"

        Food ->
            "food"

        Drink ->
            "drink"

        Shield ->
            "shield"

        Held ->
            "held"

        Jewellery ->
            "jewellery"

        Relic ->
            "relic"

        Catalyst ->
            "catalyst"

        Component ->
            "component"

        Material ->
            "material"

        Reagent ->
            "reagent"

        Resource ->
            "resource"

        ClothArmor ->
            "clothArmor"

        LeatherArmor ->
            "leatherArmor"

        ChainArmor ->
            "chainArmor"

        PlateArmor ->
            "plateArmor"

        BladeWeapon ->
            "bladeWeapon"

        CrushingWeapon ->
            "crushingWeapon"

        DaggerWeapon ->
            "daggerWeapon"

        H2hWeapon ->
            "h2hWeapon"

        StaveWeapon ->
            "staveWeapon"

        SpearWeapon ->
            "spearWeapon"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe ItemCategory
fromString enumString____ =
    case enumString____ of
        "general" ->
            Just General

        "schematic" ->
            Just Schematic

        "container" ->
            Just Container

        "clickie" ->
            Just Clickie

        "scroll" ->
            Just Scroll

        "potion" ->
            Just Potion

        "ingredient" ->
            Just Ingredient

        "food" ->
            Just Food

        "drink" ->
            Just Drink

        "shield" ->
            Just Shield

        "held" ->
            Just Held

        "jewellery" ->
            Just Jewellery

        "relic" ->
            Just Relic

        "catalyst" ->
            Just Catalyst

        "component" ->
            Just Component

        "material" ->
            Just Material

        "reagent" ->
            Just Reagent

        "resource" ->
            Just Resource

        "clothArmor" ->
            Just ClothArmor

        "leatherArmor" ->
            Just LeatherArmor

        "chainArmor" ->
            Just ChainArmor

        "plateArmor" ->
            Just PlateArmor

        "bladeWeapon" ->
            Just BladeWeapon

        "crushingWeapon" ->
            Just CrushingWeapon

        "daggerWeapon" ->
            Just DaggerWeapon

        "h2hWeapon" ->
            Just H2hWeapon

        "staveWeapon" ->
            Just StaveWeapon

        "spearWeapon" ->
            Just SpearWeapon

        _ ->
            Nothing
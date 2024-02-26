-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Object.ResourceResult exposing (..)

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


errors : SelectionSet (List String) Api.Object.ResourceResult
errors =
    Object.selectionForField "(List String)" "errors" [] (Decode.string |> Decode.list)


resource :
    SelectionSet decodesTo Api.Object.Resource
    -> SelectionSet (Maybe decodesTo) Api.Object.ResourceResult
resource object____ =
    Object.selectionForCompositeField "resource" [] object____ (Basics.identity >> Decode.nullable)
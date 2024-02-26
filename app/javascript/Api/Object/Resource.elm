-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.Object.Resource exposing (..)

import Api.Enum.ResourceResource
import Api.Enum.ResourceSize
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


createdAt : SelectionSet Api.ScalarCodecs.ISO8601DateTime Api.Object.Resource
createdAt =
    Object.selectionForField "ScalarCodecs.ISO8601DateTime" "createdAt" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecISO8601DateTime |> .decoder)


id : SelectionSet Api.ScalarCodecs.Id Api.Object.Resource
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecId |> .decoder)


locX : SelectionSet Float Api.Object.Resource
locX =
    Object.selectionForField "Float" "locX" [] Decode.float


locY : SelectionSet Float Api.Object.Resource
locY =
    Object.selectionForField "Float" "locY" [] Decode.float


locZ : SelectionSet Float Api.Object.Resource
locZ =
    Object.selectionForField "Float" "locZ" [] Decode.float


name : SelectionSet String Api.Object.Resource
name =
    Object.selectionForField "String" "name" [] Decode.string


patch :
    SelectionSet decodesTo Api.Object.Patch
    -> SelectionSet decodesTo Api.Object.Resource
patch object____ =
    Object.selectionForCompositeField "patch" [] object____ Basics.identity


resource : SelectionSet Api.Enum.ResourceResource.ResourceResource Api.Object.Resource
resource =
    Object.selectionForField "Enum.ResourceResource.ResourceResource" "resource" [] Api.Enum.ResourceResource.decoder


size : SelectionSet Api.Enum.ResourceSize.ResourceSize Api.Object.Resource
size =
    Object.selectionForField "Enum.ResourceSize.ResourceSize" "size" [] Api.Enum.ResourceSize.decoder


updatedAt : SelectionSet Api.ScalarCodecs.ISO8601DateTime Api.Object.Resource
updatedAt =
    Object.selectionForField "ScalarCodecs.ISO8601DateTime" "updatedAt" [] (Api.ScalarCodecs.codecs |> Api.Scalar.unwrapCodecs |> .codecISO8601DateTime |> .decoder)
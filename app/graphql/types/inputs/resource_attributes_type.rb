# frozen_string_literal: true

module Types
  module Inputs
    class ResourceAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String, required: true

      # we try and work these out from the name, so not required in input
      argument :resource, ResourceResourceType
      argument :size, ResourceSizeType

      argument :loc_x, Float, required: true
      argument :loc_y, Float, required: true
      argument :loc_z, Float, required: true
    end
  end
end

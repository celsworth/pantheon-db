# frozen_string_literal: true

module Types
  module Inputs
    class LocationAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :zone_id, ID

      argument :name, String
      argument :category, LocationCategoryType

      argument :loc_x, Float, required: false
      argument :loc_y, Float, required: false
      argument :loc_z, Float, required: false
    end
  end
end

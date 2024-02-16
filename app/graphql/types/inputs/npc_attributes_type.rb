# frozen_string_literal: true

module Types
  module Inputs
    class NpcAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String
      argument :zone_id, ID

      argument :loc_x, Float, required: false
      argument :loc_y, Float, required: false
      argument :loc_z, Float, required: false
    end
  end
end

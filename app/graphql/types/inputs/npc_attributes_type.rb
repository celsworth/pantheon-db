# frozen_string_literal: true

module Types
  module Inputs
    class NpcAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :zone_id, ID

      argument :name, String
      argument :subtitle, String, required: false

      argument :loc_x, Float, required: false
      argument :loc_y, Float, required: false
      argument :loc_z, Float, required: false
    end
  end
end

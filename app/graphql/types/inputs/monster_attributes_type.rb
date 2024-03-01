# frozen_string_literal: true

module Types
  module Inputs
    class MonsterAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String
      argument :location_id, ID

      argument :level, Integer, required: false
      argument :elite, Boolean, required: false
      argument :named, Boolean, required: false

      argument :loc_x, Float, required: false
      argument :loc_y, Float, required: false
      argument :loc_z, Float, required: false
      argument :roamer, Boolean, required: false
    end
  end
end

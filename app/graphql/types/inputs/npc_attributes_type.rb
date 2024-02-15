# frozen_string_literal: true

module Types
  module Inputs
    class NpcAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String, required: true
      argument :zone_id, ID, required: true
    end
  end
end

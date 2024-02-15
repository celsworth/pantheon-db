# frozen_string_literal: true

module Types
  module Inputs
    class NpcAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String
      argument :zone_id, ID
    end
  end
end

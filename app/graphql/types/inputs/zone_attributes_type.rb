# frozen_string_literal: true

module Types
  module Inputs
    class ZoneAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String, required: true
    end
  end
end

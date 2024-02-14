# frozen_string_literal: true

module Types
  module Inputs
    class CreateZoneAttributesType < GraphQL::Schema::InputObject
      argument_class(Types::BaseArgument)

      argument :name, String, required: true
    end
  end
end

# frozen_string_literal: true

module Types
  module Inputs
    class StatInputFilterType < GraphQL::Schema::InputObject
      argument_class(Types::BaseArgument)

      argument :stat, String, required: true
      argument :operator, OperatorType, required: true
      argument :value, Float, required: true
    end
  end
end

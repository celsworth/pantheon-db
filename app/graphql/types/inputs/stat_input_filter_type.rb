# frozen_string_literal: true

module Types
  module Inputs
    class StatInputFilterType < GraphQL::Schema::InputObject
      argument_class(Types::BaseArgument)

      argument :stat, String
      argument :operator, OperatorType
      argument :value, Float
    end
  end
end

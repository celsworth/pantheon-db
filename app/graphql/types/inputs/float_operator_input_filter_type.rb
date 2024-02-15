# frozen_string_literal: true

module Types
  module Inputs
    class FloatOperatorInputFilterType < GraphQL::Schema::InputObject
      argument_class(Types::BaseArgument)

      argument :operator, OperatorType
      argument :value, Float
    end
  end
end

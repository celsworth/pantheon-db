# frozen_string_literal: true

module Types
  module Inputs
    class FloatOperatorInputFilterType < GraphQL::Schema::InputObject
      argument_class(Types::BaseArgument)

      argument :operator, OperatorType, required: true
      argument :value, Float, required: true
    end
  end
end

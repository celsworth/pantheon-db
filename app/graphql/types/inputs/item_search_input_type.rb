# frozen_string_literal: true

module Types
  module Inputs
    class ItemSearchInputType < GraphQL::Schema::InputObject
      argument_class(Types::BaseArgument)

      argument :name, String
      argument :category, String
    end
  end
end

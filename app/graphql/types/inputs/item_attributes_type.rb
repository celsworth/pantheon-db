# frozen_string_literal: true

module Types
  module Inputs
    class ItemAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String, required: true

      argument :buy_price, Integer
      argument :sell_price, Integer
      argument :weight, Float, required: true
      argument :required_level, Integer

      argument :category, String
      argument :slot, String

      argument :stats, GraphQL::Types::JSON
      argument :classes, [String]
      argument :attrs, [String]

      argument :starts_quest, ID
      argument :reward_from_quest, ID
    end
  end
end

# frozen_string_literal: true

module Types
  module Inputs
    class ItemAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String

      argument :buy_price, Integer, required: false
      argument :sell_price, Integer, required: false
      argument :weight, Float
      argument :required_level, Integer, required: false

      argument :category, String, required: false, description: "Must be one of: #{Item::CATEGORIES.join(', ')}"
      argument :slot, String, required: false, description: "Must be one of: #{Item::SLOTS.join(', ')}"

      argument :stats, GraphQL::Types::JSON, required: false
      argument :classes, [String], required: false, description: "Must be one of: #{Item::CLASSES.join(', ')}"
      argument :attrs, [String], required: false

      argument :starts_quest, ID, required: false
    end
  end
end

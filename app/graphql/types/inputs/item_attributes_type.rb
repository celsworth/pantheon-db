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
      argument :public_notes, String, required: false

      argument :category, ItemCategoryType, required: false
      argument :slot, ItemSlotType, required: false

      argument :stats, StatsInputType, required: false
      argument :classes, [ClassType], required: false
      argument :attrs, [ItemAttrType], required: false

      argument :starts_quest, ID, required: false
    end
  end
end

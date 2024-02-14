# frozen_string_literal: true

module Types
  class ItemType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false
    field :vendor_copper, Integer
    field :weight, Float, null: false
    field :required_level, Integer

    field :category, String
    field :slot, String

    field :stats, GraphQL::Types::JSON
    field :classes, [String], null: false
    field :attrs, [String], null: false

    field :dropped_by, [MonsterType]
  end
end

# frozen_string_literal: true

module Types
  class ItemType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false
    field :buy_price, Integer
    field :sell_price, Integer
    field :weight, Float, null: false
    field :required_level, Integer

    field :category, String, description: <<~DESC
      Category will be one of: #{Item::CATEGORIES.join(', ')}
    DESC
    field :slot, String, description: <<~DESC
      Slot will be one of: #{Item::SLOTS.join(', ')}
    DESC

    field :stats, GraphQL::Types::JSON, description: <<~DESC
      A hash of stats on the item. Keys will all be one of: #{Item::STATS.join(', ')}
    DESC
    field :classes, [String], null: false, description: <<~DESC
      An array of classes that can use the item. Entries will all be one of: #{Item::CLASSES.join(', ')}
    DESC
    field :attrs, [String], null: false, description: <<~DESC
      An array of attributes on the item. Entries will all be one of: #{Item::ATTRS.join(', ')}
    DESC

    field :dropped_by, [MonsterType]
    field :starts_quest, QuestType
    field :rewarded_from_quests, [QuestType]

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

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

    field :category, ItemCategoryType
    field :slot, ItemSlotType

    field :stats, ItemStatsType
    field :classes, [ClassType], null: false, description: <<~DESC
      An array of classes that can use the item.
    DESC
    field :attrs, [ItemAttrType], null: false, description: <<~DESC
      An array of attributes on the item.
    DESC

    field :dropped_by, [MonsterType]
    field :starts_quest, QuestType
    field :rewarded_from_quests, [QuestType]

    field :has_screenshot, Boolean, null: false
    def has_screenshot # rubocop:disable Naming/PredicateName
      !!object.screenshot_id
    end

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

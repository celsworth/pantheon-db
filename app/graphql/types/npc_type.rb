# frozen_string_literal: true

module Types
  class NpcType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false

    field :zone, ZoneType, null: false

    field :quests_given, [QuestType], null: false
    field :quests_received, [QuestType], null: false

    field :sells_items, [ItemType], null: false
  end
end

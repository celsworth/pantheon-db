# frozen_string_literal: true

module Types
  class NpcType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false
    field :subtitle, String
    field :vendor, Boolean, null: false

    field :zone, ZoneType, null: false

    field :quests_given, [QuestType], null: false
    field :quests_received, [QuestType], null: false

    field :sells_items, [ItemType], null: false

    field :loc_x, Float
    field :loc_y, Float
    field :loc_z, Float

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

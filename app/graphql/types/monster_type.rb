# frozen_string_literal: true

module Types
  class MonsterType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false
    field :level, Integer, null: false
    field :elite, Boolean, null: false
    field :named, Boolean, null: false

    field :zone, ZoneType
    field :drops, [ItemType]

    field :loc_x, Float
    field :loc_y, Float
    field :loc_z, Float

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

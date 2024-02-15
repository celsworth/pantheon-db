# frozen_string_literal: true

module Types
  class ZoneType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false

    field :monsters, [MonsterType]

    field :npcs, [NpcType]

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # def monsters
    #  object.monsters.lazy_preload(:drops)
    # end
  end
end

# frozen_string_literal: true

module Types
  class LocationType < Types::BaseObject
    description <<~DESC
      A Location informally represents a loose "area" of Terminus.

      Locations always have an associated zone, and can optionally have either a Settlement or a Dungeon to narrow down their scope.

      So a Location might represent Availia by having zone=Thronefast and settlement=Availia

      Locations are used in Monster and Npc objects to identify where the Monster or Npc resides.
    DESC

    field :id, ID, null: false

    field :name, String, null: false
    field :zone, ZoneType, null: false
    field :settlement, SettlementType
    field :dungeon, DungeonType

    field :monsters, [MonsterType]
    field :npcs, [NpcType]

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

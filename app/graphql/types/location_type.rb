# frozen_string_literal: true

module Types
  class LocationType < Types::BaseObject
    description <<~DESC
      A Location informally represents a loose "area" of Terminus.

      Locations always have an associated zone.

      So a Location might represent Availia by having zone=Thronefast and type=settlement

      Locations are used in Monster and Npc objects to identify where the Monster or Npc resides.
    DESC

    field :id, ID, null: false

    field :name, String, null: false
    field :zone, ZoneType, null: false
    field :category, String, null: false

    field :loc_x, Float
    field :loc_y, Float
    field :loc_z, Float

    field :monsters, [MonsterType]
    field :npcs, [NpcType]

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

# frozen_string_literal: true

module Types
  class DungeonType < Types::BaseObject
    description <<~DESC
      Informally represents a dungeon (or camp) in Terminus.

      Dungeons are only used in Location objects.
    DESC

    field :id, ID, null: false

    field :name, String, null: false

    field :locations, [LocationType], null: false
    field :monsters, [MonsterType], null: false, description: <<~DESC
      Shortcut for locations -> monsters.

      An array of Monsters that can be found in this Dungeon.
    DESC
    field :npcs, [NpcType], null: false, description: <<~DESC
      Shortcut for locations -> npcs.

      An array of Npcs that can be found in this Dungeon.
    DESC

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

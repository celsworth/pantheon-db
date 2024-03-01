# frozen_string_literal: true

module Types
  class ZoneType < Types::BaseObject
    description <<~DESC
      Represents a zone of Terminus, ie Thronefast, or Avendyr's Pass.

      These are then used in Location objects.
    DESC

    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false

    field :locations, [LocationType], null: false
    field :monsters, [MonsterType], description: <<~DESC
      Shortcut for locations -> monsters
    DESC
    field :npcs, [NpcType], description: <<~DESC
      Shortcut for locations -> npcs
    DESC

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    # def monsters
    #  object.monsters.lazy_preload(:drops)
    # end
  end
end

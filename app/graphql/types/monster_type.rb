# frozen_string_literal: true

module Types
  class MonsterType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false
    field :level, Integer
    field :elite, Boolean, null: false
    field :named, Boolean, null: false

    field :public_notes, String

    field :zone, ZoneType, null: false, description: <<~DESC
      Shortcut for location -> zone. May be removed.
    DESC
    field :location, LocationType, null: false
    field :drops, [ItemType], null: false

    field :loc_x, Float
    field :loc_y, Float
    field :loc_z, Float
    field :roamer, Boolean, null: false

    field :images, [ImageType], null: false

    field :quest_objectives, [QuestObjectiveType], null: false
    field :required_for_quests, [QuestType], null: false, description: <<~DESC
      An array of Quests this Monster is listed as an objective for.
    DESC

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

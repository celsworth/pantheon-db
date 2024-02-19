# frozen_string_literal: true

module Types
  class QuestObjectiveType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :quest, QuestType, null: false

    field :item, ItemType
    field :monster, MonsterType
    field :amount, Integer

    field :readable, String, description: <<~DESC
      A dynamically generated field that attempts to summarise the objective based on all the other fields, so for example if item is set, and amount is 10, this may return "10 Wolf Pelt"

      This is mostly for convenience and is very rudimentary!
    DESC
    field :text, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

# frozen_string_literal: true

module Types
  class QuestObjectiveType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :quest, QuestType, null: false

    field :item, ItemType
    field :monster, MonsterType
    field :amount, Integer

    field :text, String, null: false
  end
end

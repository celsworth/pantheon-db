# frozen_string_literal: true

module Types
  class QuestType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :quest_objectives, [QuestObjectiveType]

    field :prereq_quest, QuestType
    field :successive_quests, [QuestType]

    field :giver, NpcType
    field :receiver, NpcType

    field :dropped_as, ItemType

    field :name, String, null: false
    field :text, String, null: false

    field :reward_items, [ItemType]
    field :reward_xp, Integer, null: false
    field :reward_copper, Integer, null: false
    field :reward_standing, Float, null: false
  end
end

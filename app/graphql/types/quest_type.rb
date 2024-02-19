# frozen_string_literal: true

module Types
  class QuestType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :quest_objectives, [QuestObjectiveType]
    field :quest_rewards, [QuestRewardType]

    field :prereq_quest, QuestType, description: 'Quest that must be complete before this one is available'
    field :successive_quests, [QuestType], description: 'Quests that open after this one is complete'

    field :giver, NpcType, description: 'Npc that starts this Quest'
    field :receiver, NpcType, description: 'Npc that completes this Quest'

    field :dropped_as, ItemType, description: 'Item that starts this Quest'

    field :name, String, null: false
    field :text, String, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

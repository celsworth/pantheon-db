# frozen_string_literal: true

module Types
  module Inputs
    class QuestObjectiveAttributesType < GraphQL::Schema::InputObject
      description <<~DESC
        Quest Objectives detail what must be accomplished for a Quest.

        If an objective requires a certain amount of mob kills or items to be collected, they can be referenced by setting monster_id and amount, or item_id and amount, accordingly.

        Set only one of item_id or monster_id per objective. Alternatively, both can be left blank, in which case fill out the text instead.
      DESC
      argument_class Types::BaseArgument

      argument :quest_id, ID, description: 'The Quest ID this objective belongs to'

      argument :text, String, required: false

      argument :item_id, ID, required: false, description: 'Item ID that must be collected for this objective'
      argument :monster_id, ID, required: false, description: 'Monster ID that must be killed for this objective'
      argument :amount, Integer, required: false, description: 'Count of items or monsters for this objective'
    end
  end
end

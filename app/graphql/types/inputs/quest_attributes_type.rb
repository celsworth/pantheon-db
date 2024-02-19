# frozen_string_literal: true

module Types
  module Inputs
    class QuestAttributesType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      argument :name, String

      argument :text, String

      argument :prereq_quest_id, ID,
               required: false,
               description: 'Quest ID that must be completed before this one is available'
      argument :dropped_as_id, ID,
               required: false,
               description: 'Item ID that starts this quest, if applicable'
      argument :giver_id, ID, required: false, description: 'Npc ID that supplies this quest'
      argument :receiver_id, ID, required: false, description: 'Npc ID that completes this quest'
    end
  end
end

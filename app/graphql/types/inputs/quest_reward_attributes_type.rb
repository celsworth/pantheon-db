# frozen_string_literal: true

module Types
  module Inputs
    class QuestRewardAttributesType < GraphQL::Schema::InputObject
      description <<~DESC
        Quest Rewards detail what you are given for completing a Quest.

        There are several optional columns - skill, item, copper, standing, xp.

        Only one of these must contain anything, and that determines what the reward is. Then, the amount must be set to how many of that reward you get.

        You can also provide an optional text.
      DESC
      argument_class Types::BaseArgument

      argument :quest_id, ID, description: 'The Quest ID this objective belongs to'

      argument :text, String, required: false

      argument :item_id, ID, required: false, description: 'Item ID that is rewarded'
      argument :skill, String,
               required: false,
               description: "Skill reward. This must be one of #{::QuestReward::SKILLS.join(', ')}"
      argument :copper, Boolean,
               required: false,
               description: 'True if this reward is for an amount of copper'
      argument :standing, Boolean,
               required: false,
               description: 'True if this reward is for an amount of standing with an NPC (the quest receiver, usually)'
      argument :xp, Boolean, required: false, description: 'True if this reward is for an amount of XP'

      argument :amount, Float, required: false, description: 'Count of whatever is rewarded'
    end
  end
end

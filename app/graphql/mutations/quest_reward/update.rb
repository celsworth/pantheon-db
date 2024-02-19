# frozen_string_literal: true

module Mutations
  module QuestReward
    class Update < BaseMutation
      type Types::Results::QuestResultType

      argument :id, ID
      argument :attributes, Types::Inputs::QuestRewardAttributesType

      def resolve(id:, attributes:)
        quest_reward = ::QuestReward.find(id)

        if quest_reward.update(**attributes)
          { quest_reward:, errors: [] }
        else
          { quest_reward: nil, errors: quest_reward.errors.full_messages }
        end
      end
    end
  end
end

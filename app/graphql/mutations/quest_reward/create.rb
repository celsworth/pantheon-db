# frozen_string_literal: true

module Mutations
  module QuestReward
    class Create < BaseMutation
      type Types::Results::QuestRewardResultType

      argument :attributes, Types::Inputs::QuestRewardAttributesType

      def resolve(attributes:)
        quest_reward = ::QuestReward.new(**attributes)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :create, quest_reward

        if quest_reward.save
          { quest_reward:, errors: [] }
        else
          { quest_reward: nil, errors: quest_reward.errors.full_messages }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Resolvers
  class QuestRewardsResolver < BaseResolver
    type [Types::QuestRewardType], null: false

    argument :id, ID, required: false

    def resolve(id: nil)
      # no need for a full Search yet

      dataset = QuestReward
      dataset = dataset.where(id:) if id
      dataset.all
    end
  end
end

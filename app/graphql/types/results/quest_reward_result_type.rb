# frozen_string_literal: true

module Types
  module Results
    class QuestRewardResultType < BaseObject
      field :quest_reward, QuestRewardType
      field :errors, [String], null: false
    end
  end
end

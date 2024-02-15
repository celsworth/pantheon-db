# frozen_string_literal: true

module Types
  module Results
    class QuestObjectiveResultType < BaseObject
      field :quest_objective, QuestObjectiveType
      field :errors, [String], null: false
    end
  end
end

# frozen_string_literal: true

module Resolvers
  class QuestObjectivesResolver < BaseResolver
    type [Types::QuestObjectiveType], null: false

    argument :id, ID, required: false

    def resolve(id: nil)
      # no need for a full Search yet

      dataset = QuestObjective
      dataset = dataset.where(id:) if id
      dataset.all
    end
  end
end

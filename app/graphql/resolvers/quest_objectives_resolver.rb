# frozen_string_literal: true

module Resolvers
  class QuestObjectivesResolver < BaseResolver
    type [Types::QuestObjectiveType], null: false

    def resolve
      QuestObjective.all
    end
  end
end

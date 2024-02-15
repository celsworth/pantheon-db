# frozen_string_literal: true

module Resolvers
  class QuestObjectiveResolver < BaseResolver
    type Types::QuestObjectiveType, null: true

    argument :id, ID

    def resolve(id:)
      QuestObjective.find(id)
    end
  end
end

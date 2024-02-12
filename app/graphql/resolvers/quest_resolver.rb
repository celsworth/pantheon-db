# frozen_string_literal: true

module Resolvers
  class QuestResolver < BaseResolver
    type Types::QuestType, null: true

    argument :id, ID

    def resolve(id:)
      Quest.find(id)
    end
  end
end

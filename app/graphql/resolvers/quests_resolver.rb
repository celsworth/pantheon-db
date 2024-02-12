# frozen_string_literal: true

module Resolvers
  class QuestsResolver < BaseResolver
    type [Types::QuestType], null: false

    def resolve
      Quest.all
    end
  end
end

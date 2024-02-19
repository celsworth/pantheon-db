# frozen_string_literal: true

module Resolvers
  class QuestsResolver < BaseResolver
    type [Types::QuestType], null: false

    argument :id, ID, required: false

    def resolve(id: nil)
      # no need for a full QuestSearch yet

      dataset = Quest
      dataset = dataset.where(id:) if id
      dataset.all
    end
  end
end

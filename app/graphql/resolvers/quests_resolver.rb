# frozen_string_literal: true

module Resolvers
  class QuestsResolver < BaseResolver
    type [Types::QuestType], null: false

    argument :id, ID, required: false

    argument :name, String, required: false
    argument :text, String, required: false

    argument :giver_id, ID, required: false
    argument :receiver_id, ID, required: false
    argument :prereq_quest_id, ID, required: false

    def resolve(**params)
      QuestSearch.new(**params).search.all
    end
  end
end

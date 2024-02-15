# frozen_string_literal: true

module Types
  module Results
    class QuestResultType < BaseObject
      field :quest, QuestType
      field :errors, [String], null: false
    end
  end
end

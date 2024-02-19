# frozen_string_literal: true

module Types
  module Results
    class MonsterResultType < BaseObject
      field :monster, MonsterType
      field :errors, [String], null: false
    end
  end
end

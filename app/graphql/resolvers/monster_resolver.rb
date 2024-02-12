# frozen_string_literal: true

module Resolvers
  class MonsterResolver < BaseResolver
    type Types::MonsterType, null: true

    argument :id, ID

    def resolve(id:)
      Monster.find(id)
    end
  end
end

# frozen_string_literal: true

module Resolvers
  class MonstersResolver < BaseResolver
    type [Types::MonsterType], null: false

    def resolve
      Monster.all
    end
  end
end

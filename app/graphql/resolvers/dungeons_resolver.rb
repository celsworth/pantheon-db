# frozen_string_literal: true

module Resolvers
  class DungeonsResolver < BaseResolver
    type [Types::DungeonType], null: false

    def resolve
      Dungeon.all
    end
  end
end

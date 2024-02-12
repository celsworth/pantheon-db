# frozen_string_literal: true

module Resolvers
  class NpcsResolver < BaseResolver
    type [Types::NpcType], null: false

    def resolve
      Npc.all
    end
  end
end

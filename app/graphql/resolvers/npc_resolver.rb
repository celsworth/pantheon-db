# frozen_string_literal: true

module Resolvers
  class NpcResolver < BaseResolver
    type Types::NpcType, null: true

    argument :id, ID

    def resolve(id:)
      Npc.find(id)
    end
  end
end

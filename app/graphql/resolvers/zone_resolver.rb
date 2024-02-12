# frozen_string_literal: true

module Resolvers
  class ZoneResolver < BaseResolver
    type Types::ZoneType, null: true

    argument :id, ID

    def resolve(id:)
      Zone.find(id)
    end
  end
end

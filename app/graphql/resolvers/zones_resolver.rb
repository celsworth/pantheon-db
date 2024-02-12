# frozen_string_literal: true

module Resolvers
  class ZonesResolver < BaseResolver
    type [Types::ZoneType], null: false

    def resolve
      Zone.all
    end
  end
end

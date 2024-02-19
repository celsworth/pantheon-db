# frozen_string_literal: true

module Resolvers
  class LocationsResolver < BaseResolver
    type [Types::LocationType], null: false

    def resolve
      Location.all
    end
  end
end

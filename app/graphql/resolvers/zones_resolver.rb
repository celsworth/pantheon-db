# frozen_string_literal: true

module Resolvers
  class ZonesResolver < BaseResolver
    type [Types::ZoneType], null: false

    argument :id, ID, required: false

    def resolve(id: nil)
      # no need for a full ZoneSearch yet

      dataset = Zone
      dataset = dataset.where(id:) if id
      dataset.all
    end
  end
end

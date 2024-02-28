# frozen_string_literal: true

module Resolvers
  class LocationsResolver < BaseResolver
    type [Types::LocationType], null: false

    argument :id, ID, required: false
    argument :zone_id, ID, required: false, description: 'Zone ID the Location must be in'

    argument :name, String, required: false
    argument :category, Types::LocationCategoryType, required: false

    def resolve(**params)
      LocationSearch.new(**params).search.all
    end
  end
end

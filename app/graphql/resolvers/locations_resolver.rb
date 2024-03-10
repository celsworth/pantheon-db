# frozen_string_literal: true

module Resolvers
  class LocationsResolver < BaseResolver
    type [Types::LocationType], null: false

    argument :id, ID, required: false
    argument :zone_id, ID, required: false, description: 'Zone ID the Location must be in'

    argument :name, String, required: false
    argument :category, Types::LocationCategoryType, required: false

    argument :has_loc_coords, Boolean, required: false, description: <<~DESC
      Set to true if you only want locations that have loc_x/loc_y coordinates.

      This is useful to filter to locations that will be visible on a map, and will exclude
      things like Locations that only represent an entire Zone.
    DESC

    def resolve(**params)
      LocationSearch.new(**params).search.all
    end
  end
end

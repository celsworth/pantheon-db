# frozen_string_literal: true

module Types
  module Results
    class LocationResultType < BaseObject
      field :location, LocationType
      field :errors, [String], null: false
    end
  end
end

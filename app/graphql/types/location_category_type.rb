# frozen_string_literal: true

module Types
  class LocationCategoryType < Types::BaseEnum
    Location::CATEGORIES_CAMEL.each do |cat|
      value cat, value: cat.underscore
    end
  end
end

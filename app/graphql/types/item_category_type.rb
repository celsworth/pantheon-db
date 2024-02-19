# frozen_string_literal: true

module Types
  class ItemCategoryType < Types::BaseEnum
    Item::CATEGORIES_CAMEL.each do |cat|
      value cat, value: cat.underscore
    end
  end
end

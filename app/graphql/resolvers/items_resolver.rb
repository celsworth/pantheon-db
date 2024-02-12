# frozen_string_literal: true

module Resolvers
  class ItemsResolver < BaseResolver
    type [Types::ItemType], null: false

    def resolve
      Item.all
    end
  end
end

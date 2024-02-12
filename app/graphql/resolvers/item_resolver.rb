# frozen_string_literal: true

module Resolvers
  class ItemResolver < BaseResolver
    type Types::ItemType, null: true

    argument :id, ID

    def resolve(id:)
      Item.find(id)
    end
  end
end

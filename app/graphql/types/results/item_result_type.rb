# frozen_string_literal: true

module Types
  module Results
    class ItemResultType < BaseObject
      field :item, ItemType
      field :errors, [String], null: false
    end
  end
end

# frozen_string_literal: true

module Types
  module Results
    class ZoneResultType < BaseObject
      field :zone, ZoneType
      field :errors, [String], null: false
    end
  end
end

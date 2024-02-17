# frozen_string_literal: true

module Resolvers
  class SettlementsResolver < BaseResolver
    type [Types::SettlementType], null: false

    argument :id, ID, required: false

    def resolve(id: nil)
      # no need for a full SettlementSearch yet

      dataset = Settlement
      dataset = dataset.where(id:) if id
      dataset.all
    end
  end
end

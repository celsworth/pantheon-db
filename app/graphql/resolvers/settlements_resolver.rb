# frozen_string_literal: true

module Resolvers
  class SettlementsResolver < BaseResolver
    include ActiveRecord::Sanitization::ClassMethods

    type [Types::SettlementType], null: false

    argument :id, ID, required: false
    argument :name, String, required: false, description: 'Filter to matching Settlement names'

    def resolve(id: nil, name: nil)
      # no need for a full SettlementSearch yet

      dataset = Settlement
      dataset = dataset.where(id:) if id
      dataset = dataset.where('name ILIKE ?', "%#{sanitize_sql_like(name)}%") if name
      dataset.all
    end
  end
end

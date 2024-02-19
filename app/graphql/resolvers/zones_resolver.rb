# frozen_string_literal: true

module Resolvers
  class ZonesResolver < BaseResolver
    include ActiveRecord::Sanitization::ClassMethods

    type [Types::ZoneType], null: false

    argument :id, ID, required: false, description: 'Filter to the given Zone ID'
    argument :name, String, required: false, description: 'Filter to matching Zone names'

    def resolve(id: nil, name: nil)
      # no need for a full ZoneSearch yet

      dataset = Zone
      dataset = dataset.where(id:) if id
      dataset = dataset.where('name ILIKE ?', "%#{sanitize_sql_like(name)}%") if name
      dataset.all
    end
  end
end

# frozen_string_literal: true

module Resolvers
  class DungeonsResolver < BaseResolver
    include ActiveRecord::Sanitization::ClassMethods

    type [Types::DungeonType], null: false

    argument :id, ID, required: false, description: 'Filter to the given Dungeon ID'
    argument :name, String, required: false, description: 'Filter to matching Dungeon names'

    def resolve(id: nil, name: nil)
      dataset = Dungeon
      dataset = dataset.where(id:) if id
      dataset = dataset.where('name ILIKE ?', "%#{sanitize_sql_like(name)}%") if name
      dataset.all
    end
  end
end

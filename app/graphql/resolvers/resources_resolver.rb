# frozen_string_literal: true

module Resolvers
  class ResourcesResolver < BaseResolver
    include ActiveRecord::Sanitization::ClassMethods

    type [Types::ResourceType], null: false

    argument :id, ID, required: false, description: 'Filter to the given Resource ID'
    argument :name, String, required: false, description: 'Filter to matching Resource names'

    argument :resource, Types::ResourceResourceType, required: false
    argument :size, Types::ResourceSizeType, required: false

    def resolve(id: nil, name: nil, resource: nil, size: nil)
      dataset = Resource
      dataset = dataset.where(id:) if id
      dataset = dataset.where('name ILIKE ?', "%#{sanitize_sql_like(name)}%") if name
      dataset = dataset.where(resource:) if resource
      dataset = dataset.where(size:) if size
      dataset.all
    end
  end
end

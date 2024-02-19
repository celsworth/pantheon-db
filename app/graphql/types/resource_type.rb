# frozen_string_literal: true

module Types
  class ResourceType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false
    field :resource, ResourceResourceType, null: false
    field :size, ResourceSizeType, null: false

    field :loc_x, Float
    field :loc_y, Float
    field :loc_z, Float

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end

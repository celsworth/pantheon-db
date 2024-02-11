# frozen_string_literal: true

module Types
  class NpcType < Types::BaseObject
    field :id, ID, null: false
    field :patch, PatchType, null: false

    field :name, String, null: false
  end
end

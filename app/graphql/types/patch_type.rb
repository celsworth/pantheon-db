# frozen_string_literal: true

module Types
  class PatchType < Types::BaseObject
    field :id, ID, null: false

    field :version, String, null: false
  end
end

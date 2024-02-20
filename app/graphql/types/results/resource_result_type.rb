# frozen_string_literal: true

module Types
  module Results
    class ResourceResultType < BaseObject
      field :resource, ResourceType
      field :errors, [String], null: false
    end
  end
end

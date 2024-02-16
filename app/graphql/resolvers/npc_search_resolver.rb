# frozen_string_literal: true

module Resolvers
  class NpcSearchResolver < BaseResolver
    type [Types::NpcType], null: false

    argument :name, String, required: false
    argument :vendor, Boolean, required: false

    def resolve(**params)
      NpcSearch.new(**params).search.all
    end
  end
end

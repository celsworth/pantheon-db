# frozen_string_literal: true

module Resolvers
  class NpcSearchResolver < BaseResolver
    type [Types::NpcType], null: false

    argument :name, String, required: false
    argument :subtitle, String, required: false
    argument :vendor, Boolean, required: false
    argument :zone_id, ID, required: false

    argument :gives_quest, ID, required: false
    argument :receives_quest, ID, required: false
    argument :sells_item, ID, required: false

    def resolve(**params)
      NpcSearch.new(**params).search.all
    end
  end
end

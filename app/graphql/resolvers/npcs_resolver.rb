# frozen_string_literal: true

module Resolvers
  class NpcsResolver < BaseResolver
    type [Types::NpcType], null: false

    argument :id, ID, required: false

    argument :name, String, required: false
    argument :subtitle, String, required: false
    argument :vendor, Boolean, required: false
    argument :location_id, ID, required: false, description: 'Location ID the Npc must be in'
    argument :zone_id, ID, required: false

    argument :gives_quest_id, ID, required: false
    argument :receives_quest_id, ID, required: false
    argument :sells_item_id, ID, required: false

    def resolve(**params)
      NpcSearch.new(**params).search.order(:name).all
    end
  end
end

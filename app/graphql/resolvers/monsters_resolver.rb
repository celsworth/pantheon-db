# frozen_string_literal: true

module Resolvers
  class MonstersResolver < BaseResolver
    type [Types::MonsterType], null: false

    argument :id, ID, required: false

    argument :name, String, required: false
    argument :elite, Boolean, required: false
    argument :named, Boolean, required: false
    argument :drops_id, ID, required: false, description: 'Item ID of something the monster drops'
    argument :location_id, ID, required: false, description: 'Location ID the monster must be in'
    argument :zone_id, ID, required: false, description: 'Zone ID the monster must be in'
    argument :level, [Types::Inputs::FloatOperatorInputFilterType], required: false

    def resolve(**params)
      MonsterSearch.new(**params).search.order(:name).all
    end
  end
end

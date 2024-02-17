# frozen_string_literal: true

module Resolvers
  class MonstersResolver < BaseResolver
    type [Types::MonsterType], null: false

    argument :name, String, required: false
    argument :elite, Boolean, required: false
    argument :named, Boolean, required: false
    argument :drops, ID, required: false, description: 'Item ID of something the monster drops'
    argument :zone_id, ID, required: false, description: 'Zone ID the monster must be in'
    argument :level, [Types::Inputs::FloatOperatorInputFilterType], required: false

    def resolve(**params)
      MonsterSearch.new(**params).search.all
    end
  end
end

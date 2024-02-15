# frozen_string_literal: true

module Resolvers
  class ItemSearchResolver < BaseResolver
    type [Types::ItemType], null: false

    argument :name, String, required: false
    argument :category, String, required: false
    argument :slot, String, required: false
    argument :class, String, required: false

    argument :dropped_by, ID, required: false
    argument :reward_from_quest, ID, required: false

    argument :stats, [Types::Inputs::StatInputFilterType], required: false
    argument :required_level, [Types::Inputs::FloatOperatorInputFilterType], required: false
    argument :weight, [Types::Inputs::FloatOperatorInputFilterType], required: false

    def resolve(**params)
      ItemSearch.new(**params).search.all
    end
  end
end

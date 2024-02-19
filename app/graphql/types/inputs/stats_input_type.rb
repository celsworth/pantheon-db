# frozen_string_literal: true

module Types
  module Inputs
    class StatsInputType < GraphQL::Schema::InputObject
      argument_class Types::BaseArgument

      Item::STATS.each do |stat|
        argument stat, Item.stats_type(stat), required: false
      end
    end
  end
end

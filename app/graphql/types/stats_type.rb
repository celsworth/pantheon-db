# frozen_string_literal: true

module Types
  class StatsType < Types::BaseObject
    description <<~DESC
      Details of stats on an Item
    DESC

    Item::STATS.each do |stat|
      field stat, Item.stats_type(stat)
    end
  end
end

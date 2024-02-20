# frozen_string_literal: true

module Types
  class ItemStatsType < Types::BaseObject
    description <<~DESC
      Details of stats on an Item
    DESC

    Item::STATS.each do |stat|
      field stat, Item.stats_type(stat)
    end
  end
end

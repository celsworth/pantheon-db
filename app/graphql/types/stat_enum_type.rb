# frozen_string_literal: true

module Types
  class StatEnumType < Types::BaseEnum
    Item::STATS_CAMEL.each do |stat|
      value stat, value: stat.underscore
    end
  end
end

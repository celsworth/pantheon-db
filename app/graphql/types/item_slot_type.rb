# frozen_string_literal: true

module Types
  class ItemSlotType < Types::BaseEnum
    Item::SLOTS_CAMEL.each do |slot|
      value slot, value: slot.underscore
    end
  end
end

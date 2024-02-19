# frozen_string_literal: true

module Types
  class ResourceSizeType < Types::BaseEnum
    Resource::SIZES.each do |slot|
      value slot, value: slot.underscore
    end
  end
end

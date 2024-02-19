# frozen_string_literal: true

module Types
  class ResourceResourceType < Types::BaseEnum
    Resource::RESOURCES_CAMEL.each do |slot|
      value slot, value: slot.underscore
    end
  end
end

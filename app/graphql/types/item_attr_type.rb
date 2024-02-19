# frozen_string_literal: true

module Types
  class ItemAttrType < Types::BaseEnum
    Item::ATTRS_CAMEL.each do |attr|
      value attr, value: attr.underscore
    end
  end
end

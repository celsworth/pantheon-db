# frozen_string_literal: true

module Types
  class ClassType < Types::BaseEnum
    Item::CLASSES.each do |cls|
      value cls, value: cls.underscore
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Item
    class Create < BaseMutation
      type Types::Results::ItemResultType

      argument :attributes, Types::Inputs::ItemAttributesType

      def resolve(attributes:)
        item = ::Item.new(**attributes)

        if item.save
          { item:, errors: [] }
        else
          { item: nil, errors: item.errors.full_messages }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Item
    class Update < BaseMutation
      type Types::Results::ItemResultType

      argument :id, ID
      argument :attributes, Types::Inputs::ItemAttributesType

      def resolve(id:, attributes:)
        item = ::Item.find(id)

        if item.update(**attributes)
          { item:, errors: [] }
        else
          { item: nil, errors: item.errors.full_messages }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Item
    class Delete < BaseMutation
      type Types::Results::ItemResultType

      argument :id, ID

      def resolve(id:)
        item = ::Item.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :delete, item

        if item.discard
          { item:, errors: [] }
        else
          { item: nil, errors: item.errors.full_messages }
        end
      end
    end
  end
end

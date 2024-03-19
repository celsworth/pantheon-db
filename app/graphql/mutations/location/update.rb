# frozen_string_literal: true

module Mutations
  module Location
    class Update < BaseMutation
      type Types::Results::LocationResultType

      argument :id, ID
      argument :attributes, Types::Inputs::LocationAttributesType

      def resolve(id:, attributes:)
        location = ::Location.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, location

        if location.update(**attributes)
          { location:, errors: [] }
        else
          { location: nil, errors: location.errors.full_messages }
        end
      end
    end
  end
end

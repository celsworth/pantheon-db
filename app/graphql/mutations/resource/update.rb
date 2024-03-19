# frozen_string_literal: true

module Mutations
  module Resource
    class Update < BaseMutation
      type Types::Results::ResourceResultType

      argument :id, ID
      argument :attributes, Types::Inputs::ResourceAttributesType

      def resolve(id:, attributes:)
        resource = ::Resource.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, resource

        if resource.update(**attributes)
          { resource:, errors: [] }
        else
          { resource: nil, errors: resource.errors.full_messages }
        end
      end
    end
  end
end

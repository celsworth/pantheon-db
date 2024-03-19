# frozen_string_literal: true

module Mutations
  module Resource
    class Create < BaseMutation
      type Types::Results::ResourceResultType

      argument :attributes, Types::Inputs::ResourceAttributesType

      def resolve(attributes:)
        resource = ::Resource.new(**attributes)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :create, resource

        if resource.save
          { resource:, errors: [] }
        else
          { resource: nil, errors: resource.errors.full_messages }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Resource
    class Create < BaseMutation
      type Types::Results::ResourceResultType

      argument :attributes, Types::Inputs::ResourceAttributesType

      def resolve(attributes:)
        resource = ::Resource.new(**attributes)

        if resource.save
          { resource:, errors: [] }
        else
          { resource: nil, errors: resource.errors.full_messages }
        end
      end
    end
  end
end

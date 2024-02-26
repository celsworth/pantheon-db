# frozen_string_literal: true

module Mutations
  module Location
    class Create < BaseMutation
      type Types::Results::LocationResultType

      argument :attributes, Types::Inputs::LocationAttributesType

      def resolve(attributes:)
        location = ::Location.new(**attributes)

        if location.save
          { location:, errors: [] }
        else
          { location: nil, errors: location.errors.full_messages }
        end
      end
    end
  end
end

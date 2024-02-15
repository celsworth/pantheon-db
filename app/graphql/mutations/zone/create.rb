# frozen_string_literal: true

module Mutations
  module Zone
    class Create < BaseMutation
      type Types::Results::ZoneResultType

      argument :attributes, Types::Inputs::ZoneAttributesType

      def resolve(attributes:)
        zone = ::Zone.new(**attributes)

        if zone.save
          { zone:, errors: [] }
        else
          { zone: nil, errors: zone.errors.full_messages }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Zone
    class Update < BaseMutation
      type Types::Payloads::ZonePayloadType

      argument :id, ID
      argument :attributes, Types::Inputs::ZoneAttributesType

      def resolve(id:, attributes:)
        zone = ::Zone.find(id)

        if zone.update(**attributes)
          { zone:, errors: [] }
        else
          { zone: nil, errors: zone.errors.full_messages }
        end
      end
    end
  end
end

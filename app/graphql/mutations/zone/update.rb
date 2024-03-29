# frozen_string_literal: true

module Mutations
  module Zone
    class Update < BaseMutation
      type Types::Results::ZoneResultType

      argument :id, ID
      argument :attributes, Types::Inputs::ZoneAttributesType

      def resolve(id:, attributes:)
        zone = ::Zone.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, zone

        if zone.update(**attributes)
          { zone:, errors: [] }
        else
          { zone: nil, errors: zone.errors.full_messages }
        end
      end
    end
  end
end

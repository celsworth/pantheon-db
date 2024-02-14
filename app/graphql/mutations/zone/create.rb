# frozen_string_literal: true

module Mutations
  module Zone
    class Create < BaseMutation
      argument :attributes, Types::Inputs::CreateZoneAttributesType

      field :zone, Types::ZoneType
      field :errors, [String], null: false

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

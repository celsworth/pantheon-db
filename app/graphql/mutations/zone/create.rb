module Mutations
  module Zone
    class Create < BaseMutation
      argument :name, String

      field :zone, Types::ZoneType
      field :errors, [String], null: false

      def resolve(name:)
        zone = ::Zone.new(name:)

        if zone.save
          {
            zone:,
            errors: []
          }
        else
          {
            zone: nil,
            errors: zone.errors.full_messages
          }
        end
      end
    end
  end
end

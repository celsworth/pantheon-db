module Resolvers
  class ZoneResolver < BaseResolver
    type Types::ZoneType, null: false

    argument :id, ID

    def resolve(id:)
      ::Zone.find(id)
    end
  end
end

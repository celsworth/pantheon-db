# frozen_string_literal: true

module Mutations
  module Npc
    class Create < BaseMutation
      type Types::Results::NpcResultType

      argument :attributes, Types::Inputs::NpcAttributesType

      def resolve(attributes:)
        npc = ::Npc.new(**attributes)

        if npc.save
          { npc:, errors: [] }
        else
          { npc: nil, errors: npc.errors.full_messages }
        end
      end
    end
  end
end

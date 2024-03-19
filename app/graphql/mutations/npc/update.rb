# frozen_string_literal: true

module Mutations
  module Npc
    class Update < BaseMutation
      type Types::Results::NpcResultType

      argument :id, ID
      argument :attributes, Types::Inputs::NpcAttributesType

      def resolve(id:, attributes:)
        npc = ::Npc.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, npc

        if npc.update(**attributes)
          { npc:, errors: [] }
        else
          { npc: nil, errors: npc.errors.full_messages }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Npc
    class Delete < BaseMutation
      type Types::Results::NpcResultType

      argument :id, ID

      def resolve(id:)
        npc = ::Npc.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :delete, npc

        if npc.discard
          { npc:, errors: [] }
        else
          { npc: nil, errors: npc.errors.full_messages }
        end
      end
    end
  end
end

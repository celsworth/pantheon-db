# frozen_string_literal: true

module Mutations
  module Monster
    class Delete < BaseMutation
      type Types::Results::MonsterResultType

      argument :id, ID

      def resolve(id:)
        monster = ::Monster.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :delete, monster

        if monster.discard
          { monster:, errors: [] }
        else
          { monster: nil, errors: monster.errors.full_messages }
        end
      end
    end
  end
end

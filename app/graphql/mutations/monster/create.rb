# frozen_string_literal: true

module Mutations
  module Monster
    class Create < BaseMutation
      type Types::Results::MonsterResultType

      argument :attributes, Types::Inputs::MonsterAttributesType

      def resolve(attributes:)
        monster = ::Monster.new(**attributes)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :create, monster

        if monster.save
          { monster:, errors: [] }
        else
          { monster: nil, errors: monster.errors.full_messages }
        end
      end
    end
  end
end

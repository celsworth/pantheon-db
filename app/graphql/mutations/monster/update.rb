# frozen_string_literal: true

module Mutations
  module Monster
    class Update < BaseMutation
      type Types::Results::MonsterResultType

      argument :id, ID
      argument :attributes, Types::Inputs::MonsterAttributesType

      def resolve(id:, attributes:)
        monster = ::Monster.find(id)

        if monster.update(**attributes)
          { monster:, errors: [] }
        else
          { monster: nil, errors: monster.errors.full_messages }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Monster
    class Create < BaseMutation
      type Types::Results::MonsterResultType

      argument :attributes, Types::Inputs::MonsterAttributesType

      def resolve(attributes:)
        monster = ::Monster.new(**attributes)

        if monster.save
          { monster:, errors: [] }
        else
          { monster: nil, errors: monster.errors.full_messages }
        end
      end
    end
  end
end

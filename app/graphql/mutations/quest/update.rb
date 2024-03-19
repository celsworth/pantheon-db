# frozen_string_literal: true

module Mutations
  module Quest
    class Update < BaseMutation
      type Types::Results::QuestResultType

      argument :id, ID
      argument :attributes, Types::Inputs::QuestAttributesType

      def resolve(id:, attributes:)
        quest = ::Quest.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, quest

        if quest.update(**attributes)
          { quest:, errors: [] }
        else
          { quest: nil, errors: quest.errors.full_messages }
        end
      end
    end
  end
end

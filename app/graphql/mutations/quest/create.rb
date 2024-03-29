# frozen_string_literal: true

module Mutations
  module Quest
    class Create < BaseMutation
      type Types::Results::QuestResultType

      argument :attributes, Types::Inputs::QuestAttributesType

      def resolve(attributes:)
        quest = ::Quest.new(**attributes)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :create, quest

        if quest.save
          { quest:, errors: [] }
        else
          { quest: nil, errors: quest.errors.full_messages }
        end
      end
    end
  end
end

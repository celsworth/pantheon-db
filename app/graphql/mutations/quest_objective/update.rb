# frozen_string_literal: true

module Mutations
  module QuestObjective
    class Update < BaseMutation
      type Types::Results::QuestResultType

      argument :id, ID
      argument :attributes, Types::Inputs::QuestObjectiveAttributesType

      def resolve(id:, attributes:)
        quest_objective = ::QuestObjective.find(id)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, quest_objective

        if quest_objective.update(**attributes)
          { quest_objective:, errors: [] }
        else
          { quest_objective: nil, errors: quest_objective.errors.full_messages }
        end
      end
    end
  end
end

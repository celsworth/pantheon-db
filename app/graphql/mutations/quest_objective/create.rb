# frozen_string_literal: true

module Mutations
  module QuestObjective
    class Create < BaseMutation
      type Types::Results::QuestObjectiveResultType

      argument :attributes, Types::Inputs::QuestObjectiveAttributesType

      def resolve(attributes:)
        quest_objective = ::QuestObjective.new(**attributes)

        raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :create, quest_objective

        if quest_objective.save
          { quest_objective:, errors: [] }
        else
          { quest_objective: nil, errors: quest_objective.errors.full_messages }
        end
      end
    end
  end
end

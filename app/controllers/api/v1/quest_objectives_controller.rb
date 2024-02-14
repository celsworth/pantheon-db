# frozen_string_literal: true

module Api
  module V1
    class QuestObjectivesController < ApiController
      def index
        render json: blueprint(QuestObjective.all)
      end

      def show
        render json: blueprint(quest_objective)
      end

      def create
        quest_objective = QuestObjective.new(quest_objective_params)
        if quest_objective.save
          render json: blueprint(quest_objective)
        else
          render json: { errors: quest_objective.errors }
        end
      end

      def update
        if quest_objective.update(quest_objective_params)
          render json: blueprint(quest_objective)
        else
          render json: { errors: quest_objective.errors }
        end
      end

      def destroy
        quest_objective = QuestObjective.find(params[:id])
        quest_objective.discard
        head 204
      end

      private

      def quest_objective
        @quest_objective ||= QuestObjective.find(params[:id])
      end

      def blueprint(quest_objective)
        QuestObjectiveBlueprint.render(quest_objective, view: :full)
      end

      def quest_objective_params
        params.permit(:text, :quest_id, :item_id, :item_amount)
      end
    end
  end
end

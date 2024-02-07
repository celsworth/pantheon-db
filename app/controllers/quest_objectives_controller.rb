# frozen_string_literal: true

class QuestObjectivesController < ApplicationController
  def index
    render json: QuestObjective.all
  end

  def show
    render json: { quest_objective: quest_objective }
  end

  def update
    if quest_objective.update(quest_objective_params)
      render json: { quest_objective: quest_objective }
    else
      render json: { errors: quest_objective.errors }
    end
  end

  # def destroy
  #  quest_objective = QuestObjective.find(params[:id])
  #  quest_objective.destroy
  # end

  private

  def quest_objective
    @quest_objective ||= QuestObjective.find(params[:id])
  end

  def quest_objective_params
    params.permit(:text, :quest_id, :item_id, :item_amount)
  end
end

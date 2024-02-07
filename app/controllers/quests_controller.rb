# frozen_string_literal: true

class QuestsController < ApplicationController
  def index
    render json: Quest.all
  end

  def show
    render json: { quest: quest }
  end

  def update
    if quest.update(quest_params)
      render json: { quest: quest }
    else
      render json: { errors: quest.errors }
    end
  end

  # def destroy
  #  quest = Quest.find(params[:id])
  #  quest.destroy
  # end

  private

  def quest
    @quest ||= Quest.find(params[:id])
  end

  def quest_params
    params.permit(:name, :giver_id, :receiver_id, :dropped_as_id, :text,
                  :reward_xp, :reward_copper, :reward_standing)
  end
end

# frozen_string_literal: true

module Api
  module V1
    class QuestsController < ApplicationController
      def index
        quests = Quest.all
        render json: QuestBlueprint.render(quests)
      end

      def show
        render json: QuestBlueprint.render(quest)
      end

      def update
        if quest.update(quest_params)
          render json: QuestBlueprint.render(quest)
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
  end
end

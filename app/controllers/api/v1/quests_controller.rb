# frozen_string_literal: true

module Api
  module V1
    class QuestsController < ApiController
      def index
        quests = Quest.all
        render json: blueprint(quests)
      end

      def show
        render json: blueprint(quest)
      end

      def create
        quest = Quest.new(quest_params)
        if quest.save
          render json: blueprint(quest)
        else
          render json: { errors: quest.errors }
        end
      end

      def update
        if quest.update(quest_params)
          render json: blueprint(quest)
        else
          render json: { errors: quest.errors }
        end
      end

      def destroy
        quest = Quest.find(params[:id])
        quest.discard
        head 204
      end

      private

      def quest
        @quest ||= Quest.find(params[:id])
      end

      def blueprint(quest)
        QuestBlueprint.render(quest, view: :full)
      end

      def quest_params
        params.permit(:name,
                      :prereq_quest_id, :giver_id, :receiver_id, :dropped_as_id,
                      :text,
                      :reward_xp, :reward_copper, :reward_standing,
                      quest_objectives_attributes: %i[id quest_id item_id monster_id amount])
      end
    end
  end
end

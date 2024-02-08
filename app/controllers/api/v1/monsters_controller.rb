# frozen_string_literal: true

module Api
  module V1
    class MonstersController < ApplicationController
      def index
        monsters = Monster.includes(:zone).all
        render json: blueprint(monsters)
      end

      def show
        render json: MonsterBlueprint.render(monster)
      end

      def create
        monster = Monster.new(monster_params)
        if monster.save
          render json: blueprint(monster)
        else
          render json: { errors: monster.errors }
        end
      end

      def update
        if monster.update(monster_params)
          render json: blueprint(monster)
        else
          render json: { errors: monster.errors }
        end
      end

      # def destroy
      #  monster = Monster.find(params[:id])
      #  monster.destroy
      # end

      private

      def monster
        @monster ||= Monster.find(params[:id])
      end

      def blueprint(monster)
        MonsterBlueprint.render(monster, view: :full)
      end

      def monster_params
        params.permit(:zone_id, :name, :level, :elite, :named)
      end
    end
  end
end

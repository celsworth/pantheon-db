# frozen_string_literal: true

module Api
  module V1
    class MonstersController < ApiController
      def index
        monsters = Monster.all
        render json: blueprint(monsters)
      end

      def show
        render json: blueprint(monster)
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
        params.permit(:zone_id, :name, :level, :elite, :named, :loc_x, :loc_y, :loc_z)
      end
    end
  end
end

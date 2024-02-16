# frozen_string_literal: true

module Api
  module V1
    class NpcsController < ApiController
      def index
        render json: blueprint(Npc.all)
      end

      def show
        render json: blueprint(npc)
      end

      def create
        npc = Npc.new(npc_params)
        if npc.save
          render json: blueprint(npc)
        else
          render json: { errors: npc.errors }
        end
      end

      def update
        if npc.update(npc_params)
          render json: blueprint(npc)
        else
          render json: { errors: npc.errors }
        end
      end

      def destroy
        npc = Npc.find(params[:id])
        npc.discard
      end

      private

      def npc
        @npc ||= Npc.find(params[:id])
      end

      def blueprint(npc)
        NpcBlueprint.render(npc, view: :full)
      end

      def npc_params
        params.permit(:zone_id, :name, :subtitle, :loc_x, :loc_y, :loc_z)
      end
    end
  end
end

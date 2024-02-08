# frozen_string_literal: true

module Api
  module V1
    class NpcsController < ApplicationController
      def index
        render json: NpcBlueprint.render(Npc.all)
      end

      def show
        render json: NpcBlueprint.render(npc)
      end

      def update
        if npc.update(npc_params)
          render json: NpcBlueprint.render(npc)
        else
          render json: { errors: npc.errors }
        end
      end

      # def destroy
      #  npc = Npc.find(params[:id])
      #  npc.destroy
      # end

      private

      def npc
        @npc ||= Npc.find(params[:id])
      end

      def npc_params
        params.permit(:zone_id, :name)
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class ZonesController < ApplicationController
      def index
        render json: ZoneBlueprint.render(Zone.all)
      end

      def show
        render json: ZoneBlueprint.render(zone)
      end

      def create
        zone = Zone.new(zone_params)
        if zone.save
          render json: ZoneBlueprint.render(zone)
        else
          render json: { errors: zone.errors }
        end
      end

      def update
        if zone.update(zone_params)
          render json: ZoneBlueprint.render(zone)
        else
          render json: { errors: zone.errors }
        end
      end

      # def destroy
      #  zone = Zone.find(params[:id])
      #  zone.destroy
      # end

      private

      def zone
        @zone ||= Zone.find(params[:id])
      end

      def zone_params
        params.permit(:name)
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class ZonesController < ApplicationController
      def index
        render json: blueprint(Zone.all)
      end

      def history
        # unversioned_attributes: :nil or :preserve could be useful for diffs
        versions = zone.versions.map { |o| o.reify(dup: true) }.compact
        render json: blueprint(versions) # view: :fields_only # no associations
      end

      def show
        render json: blueprint(zone)
      end

      def create
        zone = Zone.new(zone_params)
        if zone.save
          render json: blueprint(zone)
        else
          render json: { errors: zone.errors }
        end
      end

      def update
        if zone.update(zone_params)
          render json: blueprint(zone)
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

      def blueprint(zone)
        ZoneBlueprint.render(zone, view: :full)
      end

      def zone_params
        params.permit(:name)
      end
    end
  end
end

# frozen_string_literal: true

class ZonesController < ApplicationController
  def index
    render json: Zone.all
  end

  def show
    render json: { zone: zone }
  end

  def update
    if zone.update(zone_params)
      render json: { zone: zone }
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

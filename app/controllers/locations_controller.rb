# frozen_string_literal: true

class LocationsController < ApplicationController
  def select_for_category
    locations = Location.where(category: params[:category]).order(:name)
    render partial: 'locations/select',
           locals: { selected_id: params[:selected_id], locations: }
  end
end

# frozen_string_literal: true

class MonstersController < ApplicationController
  before_action :monster, only: %i[show edit]

  def index; end

  def show; end

  def edit; end

  def test
    locations = Location.where(category: params[:category])
    render partial: 'monsters/location',
           locals: { selected_id: params[:selected_id], locations: }
  end

  def monster
    @monster ||= Monster.find_by(id: params[:id])
  end
end

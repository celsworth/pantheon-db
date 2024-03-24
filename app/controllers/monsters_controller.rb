# frozen_string_literal: true

class MonstersController < ApplicationController
  before_action :monster, only: %i[show]

  def index
    @monsters = Monster.order(:name)
  end

  def show; end

  def edit
    head 403 unless can? :edit, monster
  end

  def update
    return head 403 unless can? :edit, monster

    if monster.update(monster_params)
      # redirect_to monster, notice: 'Saved!'
      redirect_to edit_monster_path(monster), notice: 'Changes Saved!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def test
    locations = Location.where(category: params[:category])
    render partial: 'monsters/location',
           locals: { selected_id: params[:selected_id], locations: }
  end

  def monster
    @monster ||= Monster.find_by(id: params[:id])
  end

  def monster_params
    params.require(:monster).permit(
      :name, :level, :loc_x, :loc_y, :loc_z, :public_notes, :private_notes,
      :named, :elite, :location_id, :roamer
    ).tap do |p|
      p[:named] = (p[:named] == 'on')
      p[:elite] = (p[:elite] == 'on')
      p[:roamer] = (p[:roamer] == 'on')
    end
  end
end

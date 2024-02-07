# frozen_string_literal: true

class MonstersController < ApplicationController
  def index
    render json: Monster.all
  end

  def show
    render json: { monster: monster }
  end

  def update
    if monster.update(monster_params)
      render json: { monster: monster }
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

  def monster_params
    params.permit(:zone_id, :name, :level, :elite, :named)
  end
end

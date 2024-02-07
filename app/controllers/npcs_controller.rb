# frozen_string_literal: true

class NpcsController < ApplicationController
  def index
    render json: Npc.all
  end

  def show
    render json: { npc: npc }
  end

  def update
    if npc.update(npc_params)
      render json: { npc: npc }
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

# frozen_string_literal: true

class ItemsController < ApplicationController
  def index
    render json: Item.all
  end

  def show
    render json: { item: }
  end

  def update
    if item.update(item_params)
      render json: { item: }
    else
      render json: { errors: item.errors }
    end
  end

  # def destroy
  #  item = Item.find(params[:id])
  #  item.destroy
  # end

  private

  def item
    @item ||= Item.find(params[:id])
  end

  def item_params
    params.permit(:monster_id, :name, :vendor_copper, :weight)
  end
end

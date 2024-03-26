# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :item, only: %i[show]

  # was old elm stuff
  # def new; end

  def index
    @items = Item.order(:name)
  end

  def show; end

  def edit
    head 403 unless can? :edit, item
  end

  def update
    return head 403 unless can? :edit, item

    if update_item
      redirect_to edit_item_path(item), notice: 'Changes Saved!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def dynamic_stats
    item = Item.new(item_params)
    item.stats.delete(params[:remove_stat]) if params[:remove_stat]
    add_stat = params[:add_stat] if params[:add_stat].present?

    render partial: 'items/dynamic_stats_form', locals: { item:, add_stat: }
  end

  private

  def item
    @item ||= Item.find(params[:id])
  end

  def update_item
    item.attrs = toggler_params(params[:attrs])
    item.classes = toggler_params(params[:classes])
    item.update(item_params)
  end

  def item_params
    params.require(:item).permit(:id, :name, :category, :weight,
                                 :required_level, :slot,
                                 :sell_price, :buy_price,
                                 :public_notes, :private_notes)
  end

  def toggler_params(prm)
    prm.to_unsafe_h.map do |attr, v|
      v == 'true' ? attr : nil
    end.compact
  end
end

# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :item, only: %i[show]

  # was old elm stuff
  # def new; end

  def show; end

  def item
    @item ||= Item.find_by(id: params[:id])
  end
end

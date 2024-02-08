# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        items = Item.includes(monster: :zone).all
        render json: ItemBlueprint.render(items)
      end

      def show
        render json: ItemBlueprint.render(item)
      end

      def create
        item = Item.new(item_params)
        if item.save
          render json: itemBlueprint.render(item)
        else
          render json: { errors: item.errors }
        end
      end

      def update
        if item.update(item_params)
          render json: ItemBlueprint.render(item)
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
        params.permit(:monster_id, :quest_id, :name, :category, :vendor_copper, :weight, :slot,
                      :no_trade, :soulbound,
                      classes: [],
                      stats_attributes: %i[id stat amount])
      end
    end
  end
end

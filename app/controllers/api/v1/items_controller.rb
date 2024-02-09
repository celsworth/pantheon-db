# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def search
        params = search_params.to_unsafe_hash.deep_symbolize_keys
        params[:klass] = params.delete(:class) # rename param for method
        items = Item.search(**params).all
        render json: blueprint(items)
      end

      def index
        # experimenting with very short term caching
        json = Rails.cache.fetch('items', expires_in: 5.seconds) do
          items = Item.all
          blueprint(items)
        end

        render json: json
      end

      def show
        render json: blueprint(item)
      end

      def create
        item = Item.new(item_params)
        if item.save
          render json: blueprint(item)
        else
          render json: { errors: item.errors }
        end
      end

      def update
        if item.update(item_params)
          render json: blueprint(item)
        else
          render json: { errors: item.errors }
        end
      end

      # def destroy
      #  item = Item.find(params[:id])
      #  item.destroy
      # end

      def assign
        # assign an item_id to a monster_id
        monster = Monster.find(params[:monster_id])
        item.dropped_by << monster unless item.dropped_by.include?(monster)

        head 204
      end

      def unassign
        # remove an item_id from a monster_id
        monster = Monster.find(params[:monster_id])
        item.dropped_by -= [monster]

        head 204
      end

      private

      def item
        @item ||= Item.find(params[:id])
      end

      def blueprint(item)
        ItemBlueprint.render(item, view: :full)
      end

      def item_params
        params.permit(:reward_from_quest_id, :name, :category, :vendor_copper, :weight, :slot,
                      :required_level,
                      classes: [], attrs: [], stats: {})
      end

      def search_params
        params.permit(
          :name, :class,
          attrs: [],
          stats: %i[stat operator value]
        )
      end
    end
  end
end

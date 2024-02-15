# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApiController
      rescue_from ItemSearch::InvalidOperator do
        render json: { error: 'invalid operator' }
      end

      def search
        params = search_params.to_hash.sort.to_h.deep_symbolize_keys
        fingerprint = Digest::MD5.hexdigest(params.to_s)
        json = Rails.cache.fetch("items-search-#{fingerprint}", expires_in: 5.minutes) do
          items = ItemSearch.new(**params).search.all
          blueprint(items)
        end

        render json:
      end

      def index
        # experimenting with very short term caching
        json = Rails.cache.fetch('items', expires_in: 5.seconds) do
          items = Item.all
          blueprint(items)
        end

        render json:
      end

      def show
        render json: blueprint(item)
      end

      def create
        item = Item.new(item_params)
        if item.save
          Rails.cache.clear
          render json: blueprint(item)
        else
          render json: { errors: item.errors }
        end
      end

      def update
        if item.update(item_params)
          Rails.cache.clear
          render json: blueprint(item)
        else
          render json: { errors: item.errors }
        end
      end

      def destroy
        item = Item.find(params[:id])
        item.discard
        head 204
      end

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
        params.permit(:reward_from_quest_id, :name, :category, :weight, :slot,
                      :buy_price, :sell_price,
                      :required_level,
                      classes: [], attrs: [], stats: {})
      end

      def search_params
        params.permit(
          :name, :category, :class, :slot,
          :starts_quest, :reward_from_quest, :dropped_by,
          attrs: [],
          weight: %i[operator value],
          required_level: %i[operator value],
          stats: %i[stat operator value]
        )
      end
    end
  end
end

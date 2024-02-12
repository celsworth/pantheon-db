# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :item, Types::ItemType do
      argument :id, ID
    end
    def item(id:)
      Item.find(id)
    end

    field :items, [Types::ItemType]
    def items
      Item.all
    end

    field :item_search, [Types::ItemType] do
      argument :name, String, required: false
      argument :category, String, required: false
      argument :slot, String, required: false
      argument :class, String, required: false

      argument :dropped_by, Integer, required: false
      argument :reward_from_quest, Integer, required: false

      argument :stats, [Inputs::StatInputFilterType], required: false
      argument :required_level, [Inputs::FloatOperatorInputFilterType], required: false
      argument :weight, [Inputs::FloatOperatorInputFilterType], required: false
    end
    def item_search(**params)
      ItemSearch.new(**params).search.all
    end

    field :monster, Types::MonsterType do
      argument :id, ID
    end
    def monster(id:)
      Monster.find(id)
    end

    field :monsters, [Types::MonsterType]
    def monsters
      Monster.all
    end

    field :zone, Types::ZoneType do
      argument :id, ID
    end
    def zone(id:)
      Zone.find(id)
    end

    field :zones, [Types::ZoneType]
    def zones
      Zone.all
    end
  end
end

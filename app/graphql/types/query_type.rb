# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :item, resolver: Resolvers::ItemResolver
    field :items, resolver: Resolvers::ItemsResolver

    field :item_search, [Types::ItemType] do
      argument :name, String, required: false
      argument :category, String, required: false
      argument :slot, String, required: false
      argument :class, String, required: false

      argument :dropped_by, ID, required: false
      argument :reward_from_quest, ID, required: false

      argument :stats, [Inputs::StatInputFilterType], required: false
      argument :required_level, [Inputs::FloatOperatorInputFilterType], required: false
      argument :weight, [Inputs::FloatOperatorInputFilterType], required: false
    end
    def item_search(**params)
      ItemSearch.new(**params).search.all
    end

    field :monster, resolver: Resolvers::MonsterResolver
    field :monsters, resolver: Resolvers::MonstersResolver

    field :npc, resolver: Resolvers::NpcResolver
    field :npcs, resolver: Resolvers::NpcsResolver

    field :quest, resolver: Resolvers::QuestResolver
    field :quests, resolver: Resolvers::QuestsResolver

    field :zone, resolver: Resolvers::ZoneResolver
    field :zones, resolver: Resolvers::ZonesResolver
  end
end

# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :item, resolver: Resolvers::ItemResolver
    field :items, resolver: Resolvers::ItemsResolver
    field :item_search, resolver: Resolvers::ItemSearchResolver

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

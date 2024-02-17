# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :dungeons, resolver: Resolvers::DungeonsResolver
    field :locations, resolver: Resolvers::LocationsResolver
    field :settlements, resolver: Resolvers::SettlementsResolver
    field :items, resolver: Resolvers::ItemsResolver
    field :monsters, resolver: Resolvers::MonstersResolver
    field :npcs, resolver: Resolvers::NpcsResolver
    field :quests, resolver: Resolvers::QuestsResolver
    field :quest_objectives, resolver: Resolvers::QuestObjectivesResolver
    field :quest_rewards, resolver: Resolvers::QuestRewardsResolver
    field :zones, resolver: Resolvers::ZonesResolver
  end
end

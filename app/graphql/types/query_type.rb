# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :locations, resolver: Resolvers::LocationsResolver
    field :items, resolver: Resolvers::ItemsResolver
    field :monsters, resolver: Resolvers::MonstersResolver
    field :npcs, resolver: Resolvers::NpcsResolver
    field :quests, resolver: Resolvers::QuestsResolver
    field :quest_objectives, resolver: Resolvers::QuestObjectivesResolver
    field :quest_rewards, resolver: Resolvers::QuestRewardsResolver
    field :resources, resolver: Resolvers::ResourcesResolver
    field :zones, resolver: Resolvers::ZonesResolver

    field :me, String
    def me
      context[:current_user].username
    end
  end
end

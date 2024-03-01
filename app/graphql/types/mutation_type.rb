# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_item, mutation: Mutations::Item::Create, cache_fragment: false
    field :update_item, mutation: Mutations::Item::Update, cache_fragment: false
    # field :delete_item, mutation: Mutations::Item::Delete, cache_fragment: false

    field :create_monster, mutation: Mutations::Monster::Create, cache_fragment: false
    field :update_monster, mutation: Mutations::Monster::Update, cache_fragment: false
    # field :delete_monster, mutation: Mutations::Monster::Delete, cache_fragment: false

    field :create_npc, mutation: Mutations::Npc::Create, cache_fragment: false
    field :update_npc, mutation: Mutations::Npc::Update, cache_fragment: false
    # field :delete_npc, mutation: Mutations::Npc::Delete, cache_fragment: false

    field :assign_dropped_item_to_monster, mutation: Mutations::AssignDroppedItemToMonster, cache_fragment: false
    field :remove_dropped_item_from_monster, mutation: Mutations::RemoveDroppedItemFromMonster, cache_fragment: false
    field :assign_sold_item_to_npc, mutation: Mutations::AssignSoldItemToNpc, cache_fragment: false
    field :remove_sold_item_from_npc, mutation: Mutations::RemoveSoldItemFromNpc, cache_fragment: false

    field :create_location, mutation: Mutations::Location::Create, cache_fragment: false
    field :update_location, mutation: Mutations::Location::Update, cache_fragment: false

    field :create_quest, mutation: Mutations::Quest::Create, cache_fragment: false
    field :update_quest, mutation: Mutations::Quest::Update, cache_fragment: false

    field :create_quest_objective, mutation: Mutations::QuestObjective::Create, cache_fragment: false
    field :update_quest_objective, mutation: Mutations::QuestObjective::Update, cache_fragment: false

    field :create_quest_reward, mutation: Mutations::QuestReward::Create, cache_fragment: false
    field :update_quest_reward, mutation: Mutations::QuestReward::Update, cache_fragment: false

    field :create_resource, mutation: Mutations::Resource::Create, cache_fragment: false
    field :update_resource, mutation: Mutations::Resource::Update, cache_fragment: false

    field :create_zone, mutation: Mutations::Zone::Create, cache_fragment: false
    field :update_zone, mutation: Mutations::Zone::Update, cache_fragment: false
  end
end

# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_item, mutation: Mutations::Item::Create
    field :update_item, mutation: Mutations::Item::Update
    field :delete_item, mutation: Mutations::Item::Delete

    field :create_monster, mutation: Mutations::Monster::Create
    field :update_monster, mutation: Mutations::Monster::Update
    field :delete_monster, mutation: Mutations::Monster::Delete

    field :create_npc, mutation: Mutations::Npc::Create
    field :update_npc, mutation: Mutations::Npc::Update
    field :delete_npc, mutation: Mutations::Npc::Delete

    field :assign_dropped_item_to_monster, mutation: Mutations::AssignDroppedItemToMonster
    field :remove_dropped_item_from_monster, mutation: Mutations::RemoveDroppedItemFromMonster
    field :assign_sold_item_to_npc, mutation: Mutations::AssignSoldItemToNpc
    field :remove_sold_item_from_npc, mutation: Mutations::RemoveSoldItemFromNpc

    field :create_location, mutation: Mutations::Location::Create
    field :update_location, mutation: Mutations::Location::Update

    field :create_quest, mutation: Mutations::Quest::Create
    field :update_quest, mutation: Mutations::Quest::Update

    field :create_quest_objective, mutation: Mutations::QuestObjective::Create
    field :update_quest_objective, mutation: Mutations::QuestObjective::Update

    field :create_quest_reward, mutation: Mutations::QuestReward::Create
    field :update_quest_reward, mutation: Mutations::QuestReward::Update

    field :create_resource, mutation: Mutations::Resource::Create
    field :update_resource, mutation: Mutations::Resource::Update

    field :create_zone, mutation: Mutations::Zone::Create
    field :update_zone, mutation: Mutations::Zone::Update
  end
end

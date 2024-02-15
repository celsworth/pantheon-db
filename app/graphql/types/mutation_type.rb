# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_item, mutation: Mutations::Item::Create
    field :update_item, mutation: Mutations::Item::Update
    field :delete_item, mutation: Mutations::Item::Delete

    field :create_npc, mutation: Mutations::Npc::Create
    field :update_npc, mutation: Mutations::Npc::Update
    field :delete_npc, mutation: Mutations::Npc::Delete

    field :assign_dropped_item_to_monster, mutation: Mutations::AssignDroppedItemToMonster
    field :assign_sold_item_to_npc, mutation: Mutations::AssignSoldItemToNpc

    field :create_zone, mutation: Mutations::Zone::Create
    field :update_zone, mutation: Mutations::Zone::Update
  end
end

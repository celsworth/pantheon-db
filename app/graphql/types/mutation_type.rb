# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_npc, mutation: Mutations::Npc::Create
    field :update_npc, mutation: Mutations::Npc::Update

    field :create_zone, mutation: Mutations::Zone::Create
    field :update_zone, mutation: Mutations::Zone::Update
  end
end

# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_zone, mutation: Mutations::Zone::Create
    field :update_zone, mutation: Mutations::Zone::Update
  end
end

# frozen_string_literal: true

module Mutations
  class AssignSoldItemToNpc < BaseMutation
    type Types::Results::SuccessResultType

    description "Add an item to an NPC's vendor sell list"

    argument :npc_id, ID, description: 'ID of NPC to add to'
    argument :item_id, ID, description: 'Item ID to add'

    def resolve(npc_id:, item_id:)
      npc = ::Npc.find(npc_id)
      item = ::Item.find(item_id)

      raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, npc
      raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, item

      npc.sells_items << item

      if npc.errors.empty?
        { success: true, errors: [] }
      else
        { success: false, errors: npc.errors.full_messages }
      end
    end
  end
end

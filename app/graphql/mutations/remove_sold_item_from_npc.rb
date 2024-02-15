# frozen_string_literal: true

module Mutations
  class RemoveSoldItemFromNpc < BaseMutation
    type Types::Results::SuccessResultType

    description <<~DESC
      Remove an item from an NPC's vendor sell list.
      This never fails, removing an item that was not present is a no-op and
      will return success true.
    DESC

    argument :npc_id, ID, description: 'ID of NPC to remove from'
    argument :item_id, ID, description: 'Item ID to remove'

    def resolve(npc_id:, item_id:)
      npc = ::Npc.find(npc_id)
      item = ::Item.find(item_id)

      npc.sells_items -= [item]

      # this can't fail, removal if not present is just a no-op
      { success: true, errors: [] }
    end
  end
end

# frozen_string_literal: true

module Mutations
  module Npc
    class AssignSoldItemToNpc < BaseMutation
      type Types::Results::NpcResultType

      description "Add an item to an NPC's vendor sell list"

      argument :id, ID, description: 'ID of NPC to add to'
      argument :item_id, ID, description: 'Item ID to add'

      def resolve(id:, item_id:)
        npc = ::Npc.find(id)
        item = ::Item.find(item_id)

        npc.sells_items << item

        if npc.errors.empty?
          { npc:, errors: [] }
        else
          { npc: nil, errors: npc.errors.full_messages }
        end
      end
    end
  end
end

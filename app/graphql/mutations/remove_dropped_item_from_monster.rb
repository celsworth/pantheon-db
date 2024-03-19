# frozen_string_literal: true

module Mutations
  class RemoveDroppedItemFromMonster < BaseMutation
    type Types::Results::SuccessResultType

    description <<~DESC
      Remove an item from a monster's drop table.
      This never fails, removing an item that was not present is a no-op and will return success true.
    DESC

    argument :monster_id, ID, description: 'ID of Monster to remove from'
    argument :item_id, ID, description: 'Item ID to remove'

    def resolve(monster_id:, item_id:)
      monster = ::Monster.find(monster_id)
      item = ::Item.find(item_id)

      raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, monster
      raise GraphQL::ExecutionError, 'permission denied' unless current_user&.can? :manage, item

      monster.drops -= [item]

      # this can't fail, removal if not present is just a no-op
      { success: true, errors: [] }
    end
  end
end

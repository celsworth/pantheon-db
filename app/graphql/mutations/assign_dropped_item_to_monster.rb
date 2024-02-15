# frozen_string_literal: true

module Mutations
  class AssignDroppedItemToMonster < BaseMutation
    type Types::Results::SuccessResultType

    description "Add an item to a monster's drop table"

    argument :monster_id, ID, description: 'ID of Monster to add to'
    argument :item_id, ID, description: 'Item ID to add'

    def resolve(monster_id:, item_id:)
      monster = ::Monster.find(monster_id)
      item = ::Item.find(item_id)

      monster.drops << item

      if monster.errors.empty?
        { success: true, errors: [] }
      else
        { success: false, errors: monster.errors.full_messages }
      end
    end
  end
end

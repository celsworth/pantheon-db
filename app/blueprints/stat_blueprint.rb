# frozen_string_literal: true

class StatBlueprint < Blueprinter::Base
  identifier :id

  fields :stat, :amount

  fields :item_id

  # association :item, blueprint: ItemBlueprint
end

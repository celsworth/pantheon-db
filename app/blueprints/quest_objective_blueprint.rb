# frozen_string_literal: true

class QuestObjectiveBlueprint < Blueprinter::Base
  identifier :id

  fields :text, :item_amount

  fields :item_id

  # association :item, blueprint: ItemBlueprint
end

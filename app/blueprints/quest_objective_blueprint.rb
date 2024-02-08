# frozen_string_literal: true

class QuestObjectiveBlueprint < Blueprinter::Base
  identifier :id

  view :full do
    fields :text, :item_amount

    association :item, blueprint: ItemBlueprint, view: :name_only
  end
end

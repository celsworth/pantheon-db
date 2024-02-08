# frozen_string_literal: true

class QuestObjectiveBlueprint < Blueprinter::Base
  identifier :id

  view :full do
    fields :text, :amount

    fields :created_at, :updated_at

    association :item, blueprint: ItemBlueprint, view: :name_only
    association :monster, blueprint: MonsterBlueprint, view: :name_only
  end
end

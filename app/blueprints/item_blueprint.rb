# frozen_string_literal: true

class ItemBlueprint < Blueprinter::Base
  identifier :id

  view :name_only do
    fields :name
  end

  view :full do
    include_view :name_only

    fields :category, :buy_price, :sell_price, :weight, :slot,
           :required_level, :classes, :attrs, :stats

    fields :created_at, :updated_at

    association :reward_from_quest, blueprint: QuestBlueprint, view: :name_only
    association :starts_quest, blueprint: QuestBlueprint, view: :name_only

    association :dropped_by, blueprint: MonsterBlueprint, view: :name_only
    association :sold_by, blueprint: NpcBlueprint, view: :name_only

    association :patch, blueprint: PatchBlueprint
  end
end

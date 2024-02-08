# frozen_string_literal: true

class ItemBlueprint < Blueprinter::Base
  identifier :id

  view :name_only do
    fields :name
  end

  view :full do
    include_view :name_only

    fields :category, :vendor_copper, :weight, :slot,
           :no_trade, :soulbound,
           :classes,
           :stats

    fields :created_at, :updated_at

    association :reward_from_quest, blueprint: QuestBlueprint, view: :name_only
    association :starts_quest, blueprint: QuestBlueprint, view: :name_only

    association :monsters, blueprint: MonsterBlueprint, view: :name_only
    association :stats, blueprint: StatBlueprint, view: :full
  end
end

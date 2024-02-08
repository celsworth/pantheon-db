# frozen_string_literal: true

class ItemBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :category, :vendor_copper, :weight, :slot,
         :no_trade, :soulbound,
         :classes,
         :stats

  fields :created_at, :updated_at

  fields :monster_id, :quest_id

  # association :monster, blueprint: MonsterBlueprint
  # association :quest, blueprint: QuestBlueprint
  association :stats, blueprint: StatBlueprint
end

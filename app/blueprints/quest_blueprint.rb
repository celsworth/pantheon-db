# frozen_string_literal: true

class QuestBlueprint < Blueprinter::Base
  identifier :id

  view :name_only do
    fields :name
  end

  view :full do
    fields :text, :reward_xp, :reward_copper, :reward_standing

    fields :created_at, :updated_at

    association :giver, blueprint: NpcBlueprint, view: :name_only
    association :receiver, blueprint: NpcBlueprint, view: :name_only
    association :dropped_as, blueprint: ItemBlueprint, view: :name_only

    association :quest_objectives, blueprint: QuestObjectiveBlueprint, view: :full
  end
end

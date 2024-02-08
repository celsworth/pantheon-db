# frozen_string_literal: true

class QuestBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :text, :reward_xp, :reward_copper, :reward_standing

  fields :giver_id, :receiver_id, :dropped_as_id

  # association :giver, blueprint: NpcBlueprint
  # association :receiver, blueprint: NpcBlueprint
  # association :dropped_as, blueprint: ItemBlueprint

  association :quest_objectives, blueprint: QuestObjectiveBlueprint
end

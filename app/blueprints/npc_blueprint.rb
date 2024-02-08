# frozen_string_literal: true

class NpcBlueprint < Blueprinter::Base
  identifier :id

  fields :name

  fields :zone_id

  # association :zone, blueprint: ZoneBlueprint, options: { from: :npc }
end

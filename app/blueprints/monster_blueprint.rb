# frozen_string_literal: true

class MonsterBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :level, :elite, :named

  fields :zone_id

  # association :zone, blueprint: ZoneBlueprint
end

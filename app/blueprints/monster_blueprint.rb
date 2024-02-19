# frozen_string_literal: true

class MonsterBlueprint < Blueprinter::Base
  identifier :id

  view :name_only do
    fields :name
  end

  view :full do
    include_view :name_only
    fields :level, :elite, :named

    fields :loc_x, :loc_y, :loc_z

    fields :created_at, :updated_at

    association :drops, blueprint: ItemBlueprint, view: :name_only
    association :zone, blueprint: ZoneBlueprint, view: :name_only

    association :patch, blueprint: PatchBlueprint
  end
end

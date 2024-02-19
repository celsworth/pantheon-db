# frozen_string_literal: true

class NpcBlueprint < Blueprinter::Base
  identifier :id

  view :name_only do
    fields :name
  end

  view :full do
    include_view :name_only

    fields :subtitle, :vendor

    fields :loc_x, :loc_y, :loc_z

    fields :created_at, :updated_at

    association :zone, blueprint: ZoneBlueprint, view: :name_only

    association :patch, blueprint: PatchBlueprint

    association :sells_items, blueprint: ItemBlueprint, view: :name_only
  end
end

# frozen_string_literal: true

class StatBlueprint < Blueprinter::Base
  identifier :id

  view :full do
    fields :stat, :amount

    fields :created_at, :updated_at

    association :item, blueprint: ItemBlueprint, view: :name_only

    association :patch, blueprint: PatchBlueprint
  end
end

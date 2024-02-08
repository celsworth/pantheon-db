# frozen_string_literal: true

class StatBlueprint < Blueprinter::Base
  identifier :id

  view :full do
    fields :stat, :amount
    association :item, blueprint: ItemBlueprint, view: :name_only
  end
end

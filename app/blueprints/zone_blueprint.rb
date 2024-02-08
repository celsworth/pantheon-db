# frozen_string_literal: true

class ZoneBlueprint < Blueprinter::Base
  identifier :id

  view :name_only do
    fields :name
  end

  view :full do
    include_view :name_only
  end
end

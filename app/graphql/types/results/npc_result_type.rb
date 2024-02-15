# frozen_string_literal: true

module Types
  module Results
    class NpcResultType < BaseObject
      field :npc, NpcType
      field :errors, [String], null: false
    end
  end
end

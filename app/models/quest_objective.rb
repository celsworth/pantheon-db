# frozen_string_literal: true

class QuestObjective < ApplicationRecord
  belongs_to :quest, inverse_of: :quest_objectives
  belongs_to :item, inverse_of: :dropped_as, optional: true
end

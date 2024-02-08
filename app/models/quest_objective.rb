# frozen_string_literal: true

class QuestObjective < ApplicationRecord
  belongs_to :quest, inverse_of: :quest_objectives

  belongs_to :item, optional: true
  belongs_to :monster, optional: true

  validates :text, presence: true

  # TODO: validation not both item and monster
end

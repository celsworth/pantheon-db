# frozen_string_literal: true

class QuestObjective < ApplicationRecord
  belongs_to :quest
  belongs_to :item, optional: true
end

# frozen_string_literal: true

class Stat < ApplicationRecord
  belongs_to :item

  STATS = %w[endurance intellect spell-crit-chance].freeze

  validates :item, presence: true
  validates :stat, presence: true, inclusion: { in: STATS }
  validates :amount, presence: true

  validates :stat, uniqueness: { scope: :item_id }
end

# frozen_string_literal: true

class Stat < ApplicationRecord
  belongs_to :item, inverse_of: :stats

  STATS = %w[damage attack-power hit-rating
             spell-power spell-crit-chance
             armor
             block-rating
             delay
             endurance
             strength stamina constitution agility dexterity intellect wisdom charisma].freeze

  validates :item, presence: true
  validates :stat, presence: true, inclusion: { in: STATS }
  validates :amount, presence: true

  validates :stat, uniqueness: { scope: :item_id }
end

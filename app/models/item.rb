# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :monster
  belongs_to :quest, optional: true

  CATEGORIES = %w[armour weapon held jewellery reagent].freeze
  SLOTS = %w[head shoulders hands chest legs ears fingers neck].freeze
  CLASSES = %w[cleric direlord druid enchanter monk paladin ranger rogue
               shaman summoner warrior wizard].freeze

  validates :name, presence: true, uniqueness: true
  validates :monster, presence: true
  validates :weight, presence: true

  validates :category, inclusion: { in: CATEGORIES }
  validates :slot, inclusion: { in: SLOTS }
  validates :classes, inclusion: { in: CLASSES }
end

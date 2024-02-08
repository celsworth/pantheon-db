# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :monster
  belongs_to :quest, optional: true

  has_many :stats

  accepts_nested_attributes_for :stats

  CATEGORIES = %w[armour weapon held jewellery reagent].freeze
  SLOTS = %w[head shoulders hands chest legs ears fingers neck].freeze
  CLASSES = %w[cleric direlord druid enchanter monk paladin ranger rogue
               shaman summoner warrior wizard].freeze

  validates :name, presence: true, uniqueness: true
  validates :monster, presence: true
  validates :weight, presence: true

  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :slot, allow_blank: true, inclusion: { in: SLOTS }
  validates :classes, allow_blank: true, inclusion: { in: CLASSES }
end

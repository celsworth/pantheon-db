# frozen_string_literal: true

class Item < ApplicationRecord
  has_and_belongs_to_many :monsters
  belongs_to :quest, optional: true

  has_many :stats

  accepts_nested_attributes_for :stats

  CATEGORIES = %w[general schematic
                  potion ingredient food drink
                  armour weapon shield held jewellery
                  reagent resource].freeze
  SLOTS = %w[head shoulders hands back chest waist legs feet ears fingers neck relic].freeze
  CLASSES = %w[cleric direlord druid enchanter monk paladin ranger rogue
               shaman summoner warrior wizard].freeze

  validates :name, presence: true, uniqueness: true
  validates :weight, presence: true

  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :slot, allow_blank: true, inclusion: { in: SLOTS }
  validates :classes, allow_blank: true, inclusion: { in: CLASSES }

  def self.search(text)
    where('name LIKE ?', "%#{sanitize_sql_like(text)}%")
  end
end

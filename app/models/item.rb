# frozen_string_literal: true

class Item < ApplicationRecord
  has_paper_trail

  has_and_belongs_to_many :monsters
  has_one :starts_quest, class_name: 'Quest', inverse_of: :dropped_as
  belongs_to :reward_from_quest, class_name: 'Quest', optional: true, inverse_of: :reward_items

  has_many :stats, inverse_of: :item

  accepts_nested_attributes_for :stats

  CATEGORIES = %w[general schematic
                  potion ingredient food drink
                  armour
                  crushing-weapon stave-weapon spear-weapon
                  shield held jewellery
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

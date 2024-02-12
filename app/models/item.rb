# frozen_string_literal: true

class Item < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  has_and_belongs_to_many :dropped_by, class_name: 'Monster'
  has_one :starts_quest, class_name: 'Quest', inverse_of: :dropped_as
  belongs_to :reward_from_quest, class_name: 'Quest', optional: true, inverse_of: :reward_items

  META_CATEGORIES = {
    'armor' => %w[cloth-armor leather-armor chain-armor plate-armor].freeze,
    'weapon' => %w[blade-weapon dagger-weapon stave-weapon spear-weapon].freeze
  }.freeze
  CATEGORIES = %w[general schematic container clickie scroll
                  potion ingredient food drink
                  shield held jewellery
                  catalyst component material reagent resource]
               .concat(META_CATEGORIES.values.flatten)
               .freeze

  SLOTS = %w[head shoulders hands back chest waist legs feet ears fingers neck relic].freeze

  CLASSES = %w[cleric direlord druid enchanter monk paladin ranger rogue
               shaman summoner warrior wizard].freeze

  STATS = %w[damage attack-power hit-rating
             spell-power spell-crit-chance
             health mana armor
             block-rating
             delay
             endurance
             fire-resist cold-resist poison-resist chemical-resist nature-resist magic-resist
             strength stamina constitution agility dexterity intellect wisdom charisma].freeze

  validates :name, presence: true, uniqueness: true
  validates :weight, presence: true

  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :slot, allow_blank: true, inclusion: { in: SLOTS }
  validates :classes, allow_blank: true, inclusion: { in: CLASSES }

  validate :stat_hash_valid

  private

  def stat_hash_valid
    unless stats.is_a?(Hash)
      errors.add(:stats, 'must be a hash')
      return
    end

    stats.each do |k, v|
      if STATS.include?(k)
        errors.add(:stats, "#{k}=#{v} is invalid, use numbers only") unless v.is_a?(Numeric)
      else
        errors.add(:stats, "#{k} is not a valid stats key")
      end
    end
  end
end

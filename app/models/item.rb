# frozen_string_literal: true

class Item < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  has_and_belongs_to_many :dropped_by, class_name: 'Monster', before_add: :check_dropped_by
  has_and_belongs_to_many :sold_by, class_name: 'Npc', before_add: :check_sold_by
  has_one :starts_quest, class_name: 'Quest', inverse_of: :dropped_as
  has_many :quest_rewards
  has_many :rewarded_from_quests, through: :quest_rewards, source: :quest

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

  # Support for Administrate gem saving JSONB as a string
  def classes=(value)
    self[:classes] = value.is_a?(String) ? JSON.parse(value) : value
    self[:classes] = [] if classes.nil?
  end

  # Support for Administrate gem saving JSONB as a string
  def attrs=(value)
    self[:attrs] = value.is_a?(String) ? JSON.parse(value) : value
    self[:attrs] = [] if attrs.nil?
  end

  # Support for Administrate gem saving JSONB as a string
  def stats=(value)
    self[:stats] = value.is_a?(String) ? JSON.parse(value) : value
    self[:stats] = {} if stats.nil?
  end

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

  def check_dropped_by(monster)
    return unless dropped_by.include?(monster)

    errors.add :base, 'already dropped by this monster'
    raise ActiveRecord::Rollback
  end

  def check_sold_by(npc)
    return unless sold_by.include?(npc)

    errors.add :base, 'already sold by this npc'
    raise ActiveRecord::Rollback
  end
end

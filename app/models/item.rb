# frozen_string_literal: true

class Item < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  has_and_belongs_to_many :dropped_by, class_name: 'Monster', before_add: :check_dropped_by
  has_and_belongs_to_many :sold_by, class_name: 'Npc', before_add: :check_sold_by
  has_and_belongs_to_many :images
  has_one :starts_quest, class_name: 'Quest', inverse_of: :dropped_as
  has_many :quest_rewards
  has_many :rewarded_from_quests, through: :quest_rewards, source: :quest
  has_many :quest_objectives
  has_many :required_for_quests, through: :quest_objectives, source: :quest

  META_CATEGORIES = {
    'armor' => %w[cloth_armor leather_armor chain_armor plate_armor].freeze,
    'weapon' => %w[club_weapon_1h dagger_weapon_1h fist_weapon_1h sword_weapon_1h
                   polearm_2h bo_staff_2h quarter_staff_2h].freeze
  }.freeze
  CATEGORIES = %w[general schematic container clickie scroll
                  potion ingredient food drink
                  shield held jewellery relic
                  catalyst component material reagent resource]
               .concat(META_CATEGORIES.values.flatten)
               .freeze
  CATEGORIES_CAMEL = CATEGORIES.map { |w| w.camelize(:lower) }

  # this should be in the view layer really. this is top-left of previews
  READABLE_CATEGORIES = CATEGORIES.map { |c| [c, c.titleize] }.to_h.tap do |c|
    c['club_weapon_1h'] = 'One-Handed Club'
    c['dagger_weapon_1h'] = 'One-Handed Dagger'
    c['fist_weapon_1h'] = 'One-Handed Fist Weapon'
    c['sword_weapon_1h'] = 'One-Handed Sword'
    c['polearm_2h'] = 'Two-Handed Polearm'
    c['bo_staff_2h'] = 'Two-Handed Bo Staff'
    c['quarter_staff_2h'] = 'Two-Handed Quarter Staff'

    c['cloth_armor'] = 'Cloth'
    c['leather_armor'] = 'Leather'
    c['chain_armor'] = 'Chain'
    c['plate_armor'] = 'Plate'
  end.freeze

  READABLE_SUBCATEGORIES = {
    'club_weapon_1h' => 'Crushing Weapon',
    'fist_weapon_1h' => 'Hand-to-Hand Weapon',
    'dagger_weapon_1h' => 'Dagger Weapon',
    'sword_weapon_1h' => 'Blade Weapon',
    'polearm_2h' => 'Spear Weapon',
    'bo_staff_2h' => 'Stave Weapon',
    'quarter_staff_2h' => 'Stave Weapon'
  }.freeze

  CATEGORIES_FOR_SELECT = READABLE_CATEGORIES.invert.to_a.sort.freeze

  SLOTS = %w[head shoulders hands back chest waist legs feet ears
             fingers neck relic onehanded twohanded offhand ranged].freeze
  SLOTS_CAMEL = SLOTS.map { |w| w.camelize(:lower) }

  ATTRS = %w[no_trade lifebound magic quest_item temporary unique].freeze
  ATTRS_CAMEL = ATTRS.map { |w| w.camelize(:lower) }

  # no need to camel this yet as no underscores
  CLASSES = %w[bard cleric direlord druid enchanter monk necromancer paladin
               ranger rogue shaman summoner warrior wizard].freeze

  STATS = %w[damage attack_power hit_rating
             spell_power spell_crit_chance
             health mana armor
             block_rating dodge parry
             haste_percent delay
             endurance
             health_recovery_while_resting mana_recovery_while_resting
             fire_resist cold_resist poison_resist chemical_resist nature_resist
             magic_resist shock_resist
             strength stamina constitution agility dexterity intellect wisdom charisma].freeze
  STATS_CAMEL = STATS.map { |w| w.camelize(:lower) }

  validates :name, presence: true, uniqueness: true
  validates :weight, presence: true

  validates :attrs, allow_blank: true, inclusion: { in: ATTRS }
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :classes, allow_blank: true, inclusion: { in: CLASSES }
  validates :slot, allow_blank: true, inclusion: { in: SLOTS }

  validate :stat_hash_valid

  # Should move to a global module
  def self.stats_type(stat)
    case stat.to_s
    when 'delay' then ::Float
    else ::Integer
    end
  end

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

    self[:stats] = stats.map do |k, v|
      # iterate through and convert Strings to native values (from form submits)
      # need to merge this logic with stats_type
      v = k == 'delay' ? v.to_f : v.to_i

      # also remove zeroes
      next if v.zero?

      [k, v]
    end.compact.to_h
  end

  def weapon?
    category.in?(META_CATEGORIES['weapon'])
  end

  def armor?
    category.in?(META_CATEGORIES['armor'])
  end

  def general_stats
    stats.sort.reject do |k, _v|
      %w[damage delay armor].include?(k)
    end
  end

  def available_stats
    Item::STATS - stats.keys
  end

  private

  def stat_hash_valid
    unless stats.is_a?(Hash)
      errors.add(:stats, 'must be a hash')
      return
    end

    stats.each_key do |k|
      if STATS.include?(k)
        # removed for now, HTML form submits are strings
        # errors.add(:stats, "#{k}=#{v} is invalid, use numbers only") unless v.is_a?(Numeric) || v.nil?
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

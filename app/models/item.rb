# frozen_string_literal: true

class Item < ApplicationRecord
  InvalidOperator = Class.new(StandardError)

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  has_and_belongs_to_many :dropped_by, class_name: 'Monster'
  has_one :starts_quest, class_name: 'Quest', inverse_of: :dropped_as
  belongs_to :reward_from_quest, class_name: 'Quest', optional: true, inverse_of: :reward_items

  CATEGORIES = %w[general schematic container clickie scroll
                  potion ingredient food drink
                  cloth-armor leather-armor chain-armor plate-armor
                  blade-weapon dagger-weapon stave-weapon spear-weapon
                  shield held jewellery
                  catalyst component material reagent resource].freeze

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

  class << self
    # Item.search(name: 'shield', klass: 'shaman', stats: [{ stat: 'armor', operator: '>', value: 3}], attrs: ['magic'])
    def search(name: nil, klass: nil, attrs: [], stats: [])
      q = self

      q = q.where(id: for_class(klass)) if klass
      stats.each { |stat| q = q.where(id: with_stat(**stat)) }
      attrs.each { |attr| q = q.where(id: with_attr(attr)) }
      q = q.where(id: with_name(name)) if name

      q
    end

    def with_name(name)
      where('name ILIKE ?', "%#{sanitize_sql_like(name)}%") if name
    end

    def with_stat(stat:, operator:, value:)
      raise InvalidOperator unless ['>=', '>', '<=', '<', '='].include?(operator)

      where("(stats->>?)::decimal #{operator} ?", stat, value)
    end

    def with_attr(attr)
      where('attrs @> ?', "[#{attr.to_json}]")
    end

    def for_class(klass)
      where('classes @> ?', "[#{klass.to_json}]")
    end
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
end

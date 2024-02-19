# frozen_string_literal: true

module Types
  class StatsType < Types::BaseObject
    description <<~DESC
      Details of stats on an item
    DESC

    field :damage, Int
    field :attack_power, Int
    field :hit_rating, Int
    field :spell_power, Int
    field :spell_crit_chance, Int
    field :health, Int
    field :mana, Int
    field :armor, Int
    field :block_rating, Int
    field :dodge, Int
    field :parry, Int
    field :delay, Float
    field :endurance, Int
    field :health_recovery_while_resting, Int
    field :mana_recovery_while_resting, Int
    field :fire_resist, Int
    field :cold_resist, Int
    field :poison_resist, Int
    field :chemical_resist, Int
    field :nature_resist, Int
    field :magic_resist, Int
    field :strength, Int
    field :stamina, Int
    field :constitution, Int
    field :agility, Int
    field :dexterity, Int
    field :intellect, Int
    field :wisdom, Int
    field :charisma, Int
  end
end

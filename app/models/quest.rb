# frozen_string_literal: true

class Quest < ApplicationRecord
  belongs_to :giver, class_name: 'Npc'
  belongs_to :receiver, class_name: 'Npc', optional: true

  # if set, this quest starts with this dropped item
  belongs_to :dropped_as, class_name: 'Item', optional: true

  has_many :quest_objectives

  has_many :items

  validates :name, presence: true, uniqueness: true
  validates :giver, presence: true
  validates :text, presence: true

  validates :reward_xp, presence: true
  validates :reward_copper, presence: true
  validates :reward_standing, presence: true
end

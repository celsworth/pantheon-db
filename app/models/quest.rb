# frozen_string_literal: true

class Quest < ApplicationRecord
  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  belongs_to :prereq_quest, class_name: 'Quest', optional: true, inverse_of: :successive_quests

  belongs_to :giver, class_name: 'Npc', optional: true
  belongs_to :receiver, class_name: 'Npc', optional: true
  # if set, this quest starts with this dropped item
  belongs_to :dropped_as, class_name: 'Item', optional: true, inverse_of: :starts_quest

  # TODO: validation of either dropped_as or giver?

  has_many :quest_objectives, inverse_of: :quest
  has_many :reward_items, class_name: 'Item', inverse_of: :reward_from_quest
  has_many :successive_quests, class_name: 'Quest',
                               foreign_key: :prereq_quest_id,
                               inverse_of: :prereq_quest

  validates :name, presence: true, uniqueness: true
  validates :text, presence: true

  validates :reward_xp, presence: true
  validates :reward_copper, presence: true
  validates :reward_standing, presence: true
end

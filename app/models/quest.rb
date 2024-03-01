# frozen_string_literal: true

class Quest < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  belongs_to :prereq_quest, class_name: 'Quest', optional: true, inverse_of: :successive_quests

  belongs_to :giver, class_name: 'Npc', optional: true
  belongs_to :receiver, class_name: 'Npc', optional: true
  # if set, this quest starts with this dropped item
  belongs_to :dropped_as, class_name: 'Item', optional: true, inverse_of: :starts_quest

  # TODO: validation of either dropped_as or giver?

  has_many :quest_objectives, inverse_of: :quest, dependent: :destroy
  has_many :quest_rewards, inverse_of: :quest, dependent: :destroy
  has_many :successive_quests, class_name: 'Quest',
                               dependent: :nullify,
                               foreign_key: :prereq_quest_id,
                               inverse_of: :prereq_quest

  validates :name, presence: true, uniqueness: true
  validates :text, presence: true
end

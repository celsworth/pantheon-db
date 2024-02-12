# frozen_string_literal: true

class Npc < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  belongs_to :zone

  has_many :quests_given, class_name: 'Quest', foreign_key: :giver_id
  has_many :quests_received, class_name: 'Quest', foreign_key: :receiver_id

  validates :name, presence: true, uniqueness: true
  validates :zone, presence: true
end

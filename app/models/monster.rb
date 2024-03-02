# frozen_string_literal: true

class Monster < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  belongs_to :location
  has_one :zone, through: :location

  has_and_belongs_to_many :drops, class_name: 'Item', before_add: :check_drops
  has_and_belongs_to_many :images
  has_many :quest_objectives
  has_many :required_for_quests, through: :quest_objectives, source: :quest

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  private

  def check_drops(item)
    return unless drops.include?(item)

    errors.add :base, 'already dropped by this monster'
    raise ActiveRecord::Rollback
  end
end

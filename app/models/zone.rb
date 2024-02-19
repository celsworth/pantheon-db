# frozen_string_literal: true

class Zone < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  has_many :locations
  has_many :monsters, through: :locations
  has_many :npcs, through: :locations

  validates :name, presence: true, uniqueness: true
end

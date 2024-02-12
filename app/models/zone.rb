# frozen_string_literal: true

class Zone < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  has_many :monsters
  has_many :npcs

  validates :name, presence: true, uniqueness: true
end

# frozen_string_literal: true

class Settlement < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  has_many :locations
  has_many :monsters, through: :locations
  has_many :npcs, through: :locations

  validates :name, presence: true, uniqueness: true
end

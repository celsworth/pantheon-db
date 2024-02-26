# frozen_string_literal: true

class Location < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :zone

  has_many :monsters
  has_many :npcs

  CATEGORIES = %w[dungeon settlement landmark zone].freeze

  validates :name, presence: true, uniqueness: true
  validates :category, inclusion: { in: CATEGORIES}
  validates :zone, presence: true
end

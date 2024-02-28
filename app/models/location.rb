# frozen_string_literal: true

class Location < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :zone

  has_many :monsters
  has_many :npcs

  CATEGORIES = %w[bindstone dungeon portal settlement landmark zone].freeze
  CATEGORIES_CAMEL = CATEGORIES.map { |w| w.camelize(:lower) }

  validates :name, presence: true, uniqueness: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :zone, presence: true
end

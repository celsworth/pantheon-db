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
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :zone, presence: true
  validate :not_a_duplicate

  class << self
    def near(x:, y:, range: 3) # rubocop:disable Naming/MethodParameterName
      where(loc_x: (x - range..x + range), loc_y: (y - range..y + range))
    end
  end

  def not_a_duplicate
    return if loc_x.nil? || loc_y.nil?
    return if self.class.where.not(id:).where(category:).near(x: loc_x, y: loc_y).none?

    errors.add(:base, 'too close to another location of same category, possible duplicate')
  end
end

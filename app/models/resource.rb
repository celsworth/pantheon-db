# frozen_string_literal: true

class Resource < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  belongs_to :location

  TIERS = {
    'tree' => {
      'Apple' => 1,
      'Pine' => 2

    }

  }.freeze

  # kingsbloom -> fire lily
  # hemp -> jute

  # lily share spawns

  # patch = large
  # natural garden = huge veg
  SIZES = %w[normal large huge].freeze

  RESOURCES = %w[apple pine ash oak maple walnut
                 asherite caspilrite padrium tascium slytheril
                 herb vegetable lily
                 water_reeds
                 jute cotton
                 flax
                 blackberry gloomberry].freeze
  RESOURCES_CAMEL = RESOURCES.map { |w| w.camelize(:lower) }

  validates :name, presence: true
  validates :size, presence: true, inclusion: { in: SIZES }
  validates :resource, presence: true, inclusion: { in: RESOURCES }
  validate :not_near_another_node

  class << self
    def near(x:, y:, range: 3) # rubocop:disable Naming/MethodParameterName
      where(loc_x: (x - range..x + range), loc_y: (y - range..y + range))
    end
  end

  private

  def not_near_another_node
    return if self.class.where(resource:).near(x: loc_x, y: loc_y).none?

    errors.add(:base, 'too close to another resource, possible duplicate')
  end

  # attempt to auto-set some columns
  def autoset_columns; end
end

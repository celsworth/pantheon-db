# frozen_string_literal: true

class Resource < ApplicationRecord
  include Jumploc

  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  belongs_to :location

  SIZES = %w[normal large huge].freeze

  RESOURCES = %w[apple pine ash oak maple walnut

                 asherite caspilrite hardened_caspilrite padrium tascium
                 slytheril vestium

                 herb vegetable lily
                 jute cotton flax water_reed
                 blackberry gloomberry].freeze
  RESOURCES_CAMEL = RESOURCES.map { |w| w.camelize(:lower) }

  validates :name, presence: true
  validates :size, presence: true, inclusion: { in: SIZES }
  validates :resource, presence: true, inclusion: { in: RESOURCES }
  validates :loc_x, presence: true
  validates :loc_y, presence: true
  validates :loc_z, presence: true
  validate :not_near_another_node

  class << self
    def near(x:, y:, range: 3) # rubocop:disable Naming/MethodParameterName
      where(loc_x: (x - range..x + range), loc_y: (y - range..y + range))
    end
  end

  def autofill_from_name!
    data = ResourceNameDetection.new.call(name)
    assign_attributes(data)
  rescue StandardError
    nil
  end

  private

  def not_near_another_node
    return if self.class.where.not(id:).where(resource:).near(x: loc_x, y: loc_y).none?

    errors.add(:base, 'too close to another resource, possible duplicate')
  end
end

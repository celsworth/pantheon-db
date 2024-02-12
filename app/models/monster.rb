# frozen_string_literal: true

class Monster < ApplicationRecord
  include Discard::Model
  default_scope -> { kept }

  has_paper_trail

  belongs_to :patch
  before_validation { self.patch = Patch.current }

  belongs_to :zone

  has_and_belongs_to_many :drops, class_name: 'Item'

  validates :name, presence: true, uniqueness: true
  validates :zone, presence: true
  validates :level, presence: true
end

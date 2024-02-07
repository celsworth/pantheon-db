# frozen_string_literal: true

class Monster < ApplicationRecord
  belongs_to :zone

  has_many :items

  validates :name, presence: true, uniqueness: true
  validates :zone, presence: true
  validates :level, presence: true
  validates :level, presence: true
end

# frozen_string_literal: true

class Monster < ApplicationRecord
  belongs_to :zone

  has_and_belongs_to_many :items

  validates :name, presence: true, uniqueness: true
  validates :zone, presence: true
  validates :level, presence: true
  validates :level, presence: true
end

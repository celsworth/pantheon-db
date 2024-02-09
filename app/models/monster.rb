# frozen_string_literal: true

class Monster < ApplicationRecord
  has_paper_trail

  belongs_to :zone

  has_and_belongs_to_many :drops, class_name: 'Item'

  validates :name, presence: true, uniqueness: true
  validates :zone, presence: true
  validates :level, presence: true
  validates :level, presence: true
end

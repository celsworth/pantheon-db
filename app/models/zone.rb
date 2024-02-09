# frozen_string_literal: true

class Zone < ApplicationRecord
  has_paper_trail

  has_many :monsters
  has_many :npcs

  validates :name, presence: true, uniqueness: true
end

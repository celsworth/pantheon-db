# frozen_string_literal: true

class Image < ApplicationRecord
  has_and_belongs_to_many :monsters
  has_and_belongs_to_many :npcs
  has_and_belongs_to_many :items

  validates :data, presence: true
  validates :size, presence: true
  validates :mime, presence: true
end

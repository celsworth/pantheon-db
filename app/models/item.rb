# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :monster

  validates :name, presence: true, uniqueness: true
  validates :monster, presence: true
  validates :weight, presence: true
end

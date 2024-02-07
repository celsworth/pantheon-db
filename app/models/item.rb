# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :monster

  CATEGORIES = %w[armour weapon held jewellery reagent].freeze
  enum :category, CATEGORIES.zip(CATEGORIES).to_h, validate: true

  SLOTS = %w[head shoulders hands chest legs ears fingers neck].freeze
  enum :slot, SLOTS.zip(SLOTS).to_h

  validates :name, presence: true, uniqueness: true
  validates :monster, presence: true
  validates :weight, presence: true
end

# frozen_string_literal: true

class Monster < ApplicationRecord
  belongs_to :zone

  has_many :items
end

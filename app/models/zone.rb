# frozen_string_literal: true

class Zone < ApplicationRecord
  has_many :monsters
end

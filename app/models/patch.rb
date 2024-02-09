# frozen_string_literal: true

class Patch < ApplicationRecord
  validates :version, presence: true, uniqueness: true

  def self.current
    Rails.cache.fetch('current_patch', expires_in: 10.minutes) do
      order(created_at: :desc).first
    end
  end
end

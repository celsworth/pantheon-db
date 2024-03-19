# frozen_string_literal: true

# not yet an ActiveRecord model
class User < ApplicationRecord
  delegate :can?, :cannot?, to: :ability

  ROLES = %w[admin contributor member].freeze

  ADMINS = %w[password-login].freeze

  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES }

  def admin?
    role == 'admin' || username.in?(ADMINS)
  end

  def contributor?
    role == 'contributor' || admin?
  end

  def ability
    @ability ||= Ability.new(self)
  end
end

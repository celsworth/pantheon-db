# frozen_string_literal: true

ADMINS = %w[
  caesium6181
  iamsemper
  oukbok
  password-login
].freeze

# not yet an ActiveRecord model
class User
  def initialize(username:)
    @username = username
  end

  def admin?
    @username.in?(ADMINS)
  end
end

# frozen_string_literal: true

# not yet an ActiveRecord model
class User
  def initialize(username:)
    @username = username
  end

  def admin?
    @username == 'chris'
  end
end

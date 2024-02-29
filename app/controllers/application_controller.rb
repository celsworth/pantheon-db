# frozen_string_literal: true

class ApplicationController < ActionController::Base
  attr_reader :current_user

  before_action do
    @current_user = User.new(username: 'chris')
  end
end

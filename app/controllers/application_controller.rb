# frozen_string_literal: true

class ApplicationController < ActionController::Base
  wrap_parameters false

  helper_method :current_user

  def current_user
    return unless session[:current_user]

    @current_user ||= User.find_by(username: session[:current_user])
  end
end

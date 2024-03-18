# frozen_string_literal: true

class ApplicationController < ActionController::Base
  wrap_parameters false

  helper_method :current_user

  def current_user
    @current_user ||= session[:current_user]
  end
end

# frozen_string_literal: true

class UsersController < ApplicationController
  def login
    return unless current_user || params[:password] == ENV.fetch('PASSWORD')

    # pretend everyone is admin who logs in here..
    session[:current_user] = 'password-login'

    redirect_to root_path
  end

  def logout
    reset_session
    session.destroy
    redirect_to root_path
  end
end

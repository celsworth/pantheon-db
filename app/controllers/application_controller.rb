# frozen_string_literal: true

class ApplicationController < ActionController::Base
  wrap_parameters false

  helper_method :current_user, :guild_member?

  def current_user
    return @current_user if @current_user
    return unless session[:current_user]

    @current_user ||= User.find_by(username: session[:current_user])
  end

  def guild_member?
    access_token = session.dig(:discord, 'access_token')
    discord = Discord.new(access_token:)
    access_token ? discord.petrichor_member? : false
  end
end

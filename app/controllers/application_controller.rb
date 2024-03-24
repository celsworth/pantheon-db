# frozen_string_literal: true

class ApplicationController < ActionController::Base
  wrap_parameters false

  helper_method :current_user, :guild_member?

  def access_token
    @access_token ||= if (auth = request.headers['Authorization']&.match(/Bearer (.*)/))
                        auth[1]
                      else
                        session.dig(:discord, 'access_token')
                      end
  end

  def current_username
    @current_username ||= if session[:current_user].present?
                            session[:current_user]
                          elsif access_token
                            discord.verify_discord_access_token
                          end
  end

  def guild_member?
    @guild_member ||= access_token ? discord.petrichor_member? : false
  end

  def current_user
    return unless current_username

    @current_user ||= User.find_by(username: current_username).tap do |user|
      Sentry.set_user(username: user&.username)
    end
  end

  def discord
    @discord ||= Discord.new(access_token:)
  end
end

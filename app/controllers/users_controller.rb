# frozen_string_literal: true

class UsersController < ApplicationController
  def login
    return if current_user

    oauth_client = Discord.oauth_client
    redirect_to oauth_client.auth_code.authorize_url(redirect_uri: callback_url,
                                                     scope: 'identify guilds guilds.members.read'),
                allow_other_host: true
  end

  def logout
    reset_session
    session.destroy
    redirect_to root_path
  end

  def oauth2_callback
    # we don't get a code if user cancels
    return redirect_to root_path unless params[:code]

    oauth_client = Discord.oauth_client
    tokens = oauth_client.auth_code.get_token(params[:code],
                                              redirect_uri: callback_url).response.parsed
    session[:discord] = tokens
    discord = Discord.new(access_token: tokens['access_token'])
    session[:current_user] = discord.verify_discord_access_token

    redirect_to root_path
  end

  private

  def callback_url
    URI.join(ENV.fetch('BASE_URL'), '/oauth2/callback')
  end
end

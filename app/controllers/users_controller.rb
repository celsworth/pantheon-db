# frozen_string_literal: true

class UsersController < ApplicationController
  include Discord

  def login
    return if current_user

    redirect_to oauth_client.auth_code.authorize_url(redirect_uri: callback_url,
                                                     scope: 'identify guilds'),
                allow_other_host: true
  end

  def logout
    reset_session
    session.destroy
    redirect_to root_path
  end

  def oauth2_callback
    tokens = oauth_client.auth_code.get_token(params[:code],
                                              redirect_uri: callback_url).response.parsed
    session[:discord] = tokens
    session[:current_user] = verify_discord_access_token(tokens['access_token'])

    redirect_to root_path
  end
end

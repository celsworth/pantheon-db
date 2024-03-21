# frozen_string_literal: true

module Discord
  extend ActiveSupport::Concern

  def verify_discord_access_token(access_token)
    Rails.cache.fetch("discord-token-#{access_token}", expires_in: 1.day) do
      access = OAuth2::AccessToken.from_hash(oauth_client, access_token:)
      response = access.get('/api/v10/users/@me')
      body = JSON.parse(response.body)
      body['username']
    end
  rescue StandardError
    nil
  end

  def petrichor_member?(access_token)
    Rails.cache.fetch("discord-is-guild-member-#{access_token}", expires_in: 1.day) do
      access = OAuth2::AccessToken.from_hash(oauth_client, access_token:)
      response = access.get('/api/v10/users/@me/guilds')
      body = JSON.parse(response.body)
      body.map { _1['name'] }.include?('PETRICHOR [EU]-GUILD')
    end
  end

  def oauth_client
    @oauth_client ||= OAuth2::Client.new('1219698521817485323', ENV.fetch('DISCORD_CLIENT_SECRET'),
                                         site: 'https://discord.com',
                                         authorize_url: '/oauth2/authorize',
                                         token_url: '/api/v10/oauth2/token')
  end

  def callback_url
    URI.join(ENV.fetch('BASE_URL'), '/oauth2/callback')
  end
end

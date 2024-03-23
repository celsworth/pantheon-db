# frozen_string_literal: true

class Discord
  attr_reader :access_token

  PETRICHOR_RECRUIT_ROLE_ID = '696006580096860241'
  PETRICHOR_MEMBER_ROLE_ID = '696006207210782810'
  PETRICHOR_SMS_ROLE_ID = '1183355012202643536'
  PETRICHOR_SPS_ROLE_ID = '1208078191231631481'
  PETRICHOR_COUNCIL_ROLE_ID = '696024586294394941'

  class << self
    def oauth_client
      @oauth_client ||= OAuth2::Client.new('1219698521817485323', ENV.fetch('DISCORD_CLIENT_SECRET'),
                                           site: 'https://discord.com',
                                           authorize_url: '/oauth2/authorize',
                                           token_url: '/api/v10/oauth2/token')
    end
  end
  def initialize(access_token:)
    @access_token = access_token
  end

  def verify_discord_access_token
    return nil unless access_token

    key = "discord-user-for-#{access_token}"
    Rails.cache.fetch(key, expires_in: 1.hour) do
      response = access.get('/api/v10/users/@me')
      body = JSON.parse(response.body)
      body['username']
    end
  rescue StandardError => e
    Sentry.capture_exception(e)
    nil
  end

  def petrichor_member?
    petrichor_user_roles.include?(PETRICHOR_MEMBER_ROLE_ID)
  rescue StandardError => e
    Sentry.capture_exception(e)
    false
  end

  def access
    @access ||= OAuth2::AccessToken.from_hash(self.class.oauth_client, access_token:)
  end

  # return the Petrichor guild object, or nil
  def petrichor_object
    return nil unless access_token

    key = "discord-petrichor_object-#{access_token}"
    Rails.cache.fetch(key, expires_in: 1.hour) do
      Rails.logger.info 'Get Guilds'
      response = access.get('/api/v10/users/@me/guilds')
      body = JSON.parse(response.body)
      body.find { _1['name'] == 'PETRICHOR [EU]-GUILD' }
    end
  end

  def petrichor_user_roles
    return [] unless access_token

    key = "discord-petrichor_user_roles-#{access_token}"
    Rails.cache.fetch(key, expires_in: 1.hour) do
      petrichor = petrichor_object
      return [] unless petrichor

      Rails.logger.info 'Get Guild Roles'
      response = access.get("/api/v10/users/@me/guilds/#{petrichor['id']}/member")
      body = JSON.parse(response.body)
      body['roles']
    end
  end
end

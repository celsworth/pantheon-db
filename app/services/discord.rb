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
  end

  def initialize(access_token:)
    @access_token = access_token
  end

  def petrichor_member?
    Rails.cache.fetch("discord-is-petrichor-member-#{access_token}", expires_in: 1.day) do
      petrichor_user_roles.include?(PETRICHOR_MEMBER_ROLE_ID)
    end
  rescue StandardError
    false
  end

  def access
    @access ||= OAuth2::AccessToken.from_hash(self.class.oauth_client, access_token:)
  end

  # return the Petrichor guild object, or nil
  def petrichor_object
    response = access.get('/api/v10/users/@me/guilds')
    body = JSON.parse(response.body)
    body.find { _1['name'] == 'PETRICHOR [EU]-GUILD' }
  end

  def petrichor_user_roles
    petrichor = petrichor_object
    return [] unless petrichor

    response = access.get("/api/v10/users/@me/guilds/#{petrichor['id']}/member")
    body = JSON.parse(response.body)
    body['roles']
  end
end

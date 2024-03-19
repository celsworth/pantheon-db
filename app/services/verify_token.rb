# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class VerifyToken
  class << self
    def call(access_token)
      Rails.cache.fetch("discord-token-#{access_token}", expires_in: 1.day) do
        r = Net::HTTP.get_response(URI('https://discord.com/api/v10/users/@me'),
                                   'Authorization' => "Bearer #{access_token}")
        return unless r.code == '200'

        body = JSON.parse(r.body)
        body['username']
      end
    rescue StandardError
      nil
    end
  end
end

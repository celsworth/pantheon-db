# frozen_string_literal: true

GraphQL::FragmentCache.configure do |config|
  config.default_options = {
    cache_key: -> { Rails.cache.fetch('graphql_cache_key') },
    expires_in: 10.minutes
  }
end

# frozen_string_literal: true

expires_in = Rails.env.production? ? 10.minutes : 1.second

GraphQL::FragmentCache.configure do |config|
  config.default_options = {
    cache_key: -> { Rails.cache.fetch('graphql_cache_key') },
    cache_fragment: { context_key: :current_user },
    expires_in:
  }
end

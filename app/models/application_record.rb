# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  after_commit do
    # bust the entire GraphQL::FragmentCache on any database update.
    # this is sub-optimal but it will do for now until we run into perf issues.
    Rails.cache.write('graphql_cache_key', SecureRandom.uuid)
  end
end

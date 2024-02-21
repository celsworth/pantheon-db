# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PantheonDb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    #
    config.hosts << 'yrk.cae.me.uk:3000'
    config.hosts << 'localhost:3000'

    # https://stackoverflow.com/questions/70401077/rails-7-asset-pipeline-sasscsyntaxerror-with-tailwind
    # sassc-rails incompatibility or something.
    config.assets.css_compressor = nil

    # fix Tried to load unspecified class: ActiveSupport::TimeWithZone (Psych::DisallowedClass)
    config.active_record.yaml_column_permitted_classes =
      [Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone]
  end
end

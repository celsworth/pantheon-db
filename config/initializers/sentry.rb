# frozen_string_literal: true

Sentry.init do |config|
  # enable performance monitoring
  config.enable_tracing = true

  # get breadcrumbs from logs
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  config.enabled_environments = %w[production staging]

  config.send_default_pii = true
end

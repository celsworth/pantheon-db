# frozen_string_literal: true

Sentry.init do |config|
  # enable performance monitoring
  config.enable_tracing = true

  # get breadcrumbs from logs
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
end

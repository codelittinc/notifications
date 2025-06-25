# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  config.hosts << 'notifications-api.notifications.dev.convox'
  config.hosts << 'notifications-api'
  config.hosts << '.sa.ngrok.io'
  config.hosts << '.ngrok.io'
  config.hosts << '.tunnel.pyjam.as'

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  config.action_controller.perform_caching = true

  # Use Redis if available, otherwise fallback to memory cache
  if ENV['REDIS_URL'].present?
    config.cache_store = :redis_cache_store, { 
      url: ENV.fetch('REDIS_URL', nil),
      connect_timeout: 2,
      read_timeout: 1,
      write_timeout: 1,
      reconnect_attempts: 1
    }
  else
    Rails.logger.warn "REDIS_URL not set, using memory cache store"
    config.cache_store = :memory_store, { size: 64.megabytes }
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end

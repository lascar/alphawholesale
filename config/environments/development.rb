Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # mail
  config.active_job.queue_adapter = :sidekiq
  config.action_mailer.perform_deliveries = true
  # care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  if Rails.application.credentials && Rails.application.credentials.mail[:development]
    config.action_mailer.default_url_options =
      { host: Rails.application.credentials.mail[:development][:HOST],
        port: Rails.application.credentials.mail[:development][:HOST_PORT] }
	  config.action_mailer.smtp_settings = {
      address: Rails.application.credentials.mail[:development][:ADDRESS],
		  user_name: Rails.application.credentials.mail[:development][:USER_NAME],
		  password: Rails.application.credentials.mail[:development][:PASSWORD],
		  authentication: Rails.application.credentials.mail[:development][:AUTHENTICATION],
		  enable_starttls_auto: Rails.application.credentials.mail[:development][:ENABLE_STARTTLS_AUTO],
	  }
  else
    config.action_mailer.default_url_options =
     { host: ["HOST"],
       port: ["HOST_PORT"] }
    config.action_mailer.smtp_settings = {
      address: ["ADDRESS"],
      user_name: ["USER_NAME"],
      password: ["PASSWORD"],
      authentication: ["AUTHENTICATION"],
      enable_starttls_auto: ["ENABLE_STARTTLS_AUTO"],
    }
  end

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # config.assets.debug = true

  # Suppress logger output for asset requests.
  # config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  # for subdomain locale
  config.action_dispatch.tld_length = 0
end

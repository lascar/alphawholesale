require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Alphawholesale
  class Application < Rails::Application
    config.i18n.available_locales = [:en, :fr, :es]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :en
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |g|
      g.test_framework  :rspec, :fixture => true, :model_specs => false, :view_specs => false, helper_specs: false, request_specs: false
      g.integration_tool :rspec, :fixture => true, :views => true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
    config.models_auth = ['Broker', 'Supplier', 'Customer']
    config.autoload_paths += %W(#{config.root}/helpers)
    config.autoload_paths += %W(#{config.root}/lib)
  end
end

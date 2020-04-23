# config/initializers/sidekiq.rb

Sidekiq.configure_server do |config|
  config.redis = { url: url: ENV['URL'] || 'redis://localhost:6379/0', namespace: "app3_sidekiq_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: url: ENV['URL'] || 'redis://localhost:6379/0', namespace: "app3_sidekiq_#{Rails.env}" }
end

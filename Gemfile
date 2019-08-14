source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'delayed_job_active_record'
gem 'daemons'
group :production do
  gem 'puma', '~> 3.11'
  # for heroku
  gem "rack-timeout"
end
# webpack
gem 'webpacker', '>= 3.5.5'

# device
gem 'devise', '>= 4.6.0'
# pundit
gem 'pundit'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# gem 'flag-icons-rails'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
group :development, :test do
  gem 'rspec-rails', '>= 3.8.2'
  # gem 'i18n-debug'
  gem 'reek'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.7.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'erd', '>= 0.6.3', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'factory_bot_rails', '>= 5.0.1'
  gem 'database_cleaner'
  gem 'capybara', '>= 3.13.2', '< 4.0'
  gem 'shoulda'
  gem 'rails-controller-testing', '>= 1.0.4'
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

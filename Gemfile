source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
gem 'sidekiq'
gem 'redis-namespace'
group :production do
  gem 'puma', '~> 5.6'
  # for heroku
  gem "rack-timeout"
end
# webpack
gem 'webpacker', '~> 5.x'

# device
gem 'devise', '>= 4.7.1'
# pundit
gem 'pundit'
# turbolink
# gem 'turbolinks', '~> 5'
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
gem 'bootsnap', '>= 1.4.2', require: false
gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof'
gem 'memory_profiler'
group :development, :test do
  gem 'rspec-rails', '~> 4.0.0.beta2'
  #gem 'rspec-rails'
  # gem 'i18n-debug'
  gem 'reek'
  gem 'byebug'
  gem 'pry'
  gem 'pry-byebug'
end

group :development do
  gem 'webrick'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'factory_bot_rails'
  gem 'database_cleaner'
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'shoulda'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'bullet'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

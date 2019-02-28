# config/initializers/cloudfront.rb
# https://ricostacruz.com/til/rails-and-cloudfront
if Rails.env == "production"
  Rails.application.config.middleware.use CloudfrontDenier,
    target: 'https://alphawholesale.herokuapp.com'
end

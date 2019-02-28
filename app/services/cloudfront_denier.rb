# app/services/cloudfront_denier.rb
# https://ricostacruz.com/til/rails-and-cloudfront

# Middleware to deny CloudFront requests to non-packs
# http://ricostacruz.com/til/rails-and-cloudfront
class CloudfrontDenier
  def initialize(app, options = {})
    @app = app
    @target = options[:target] || '/'
  end

  def call(env)
    if cloudfront?(env) && !pack?(env)
      [302, { 'Location' => @target }, []]
    else
      @app.call(env)
    end
  end

  def pack?(env)
    env['PATH_INFO'] =~ %r{^/packs}
  end

  def cloudfront?(env)
    env['HTTP_USER_AGENT'] == 'Amazon CloudFront'
  end
end

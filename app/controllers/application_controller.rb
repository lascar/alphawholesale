class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper
  protect_from_forgery

  before_action :set_locale
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protected
  # !important for devise
  def after_sign_in_path_for(resource)
    '/' + resource.class.name.downcase.pluralize + '/' + resource.id.to_s
  end

  def authenticate_user!
    if customer_signed_in? || supplier_signed_in? || broker_signed_in?
      scope = if customer_signed_in?
                :customer
              elsif supplier_signed_in?
                :supplier
              elsif broker_signed_in?
                :broker
              end
      opts = {scope: scope}
      warden.authenticate!(opts) if !devise_controller? || opts.delete(:force)
    else
      redirect_to "/", alert: I18n.t('devise.failure.unauthenticated')
      return
    end
  end

  def current_user
    current_user_type(user_type)
  end

  def extract_locale_from_domain
    if !request.domain.nil? && request.domain !~ /localhost/
      parsed_locale = request.domain.match(/[a-z]*\.([a-z.]*)/)[1]
      if parsed_locale == "co.uk" || parsed_locale == "us"
        parsed_locale = "en"
      end
      I18n.available_locales.map(&:to_s).include?(parsed_locale) ?
        parsed_locale.to_s.strip.to_sym : :en
    end
  end

  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first
    locale = I18n.available_locales.map(&:to_s).include?(parsed_locale) ?
      parsed_locale : I18n.default_locale
    locale.to_s.strip.to_sym
  end

  def set_locale
    I18n.locale = extract_locale_from_domain ||
     extract_locale_from_subdomain
  end

  private
  def user_not_authorized
    if current_user
      user_type = current_user.class.name.downcase
      path = '/' + user_type.pluralize + '/' + current_user.id.to_s
      flash[:alert] = I18n.t('devise.errors.messages.not_authorized')
    else
      path = '/'
      flash[:alert] = I18n.t('devise.failure.unauthenticated')
    end
    redirect_to path
  end
end

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Permissions
  protect_from_forgery

	before_action :set_locale
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

  def verify_permission_user
    current_user_id = current_user ? current_user.id : nil
    id = params[:id] || current_user_id
    PERMISSIONS[controller_name.to_sym][action_name.to_sym].
     call(self, current_user, id)
  end

  def verify_permission
    object = controller_name.classify.
     constantize.find_by_id params[:id]
    id = case user_type
         when 'supplier'
           then
           object && object.has_attribute?('supplier_id') ?
            object.supplier_id : nil
         when 'customer'
           object && object.has_attribute?('customer_id') ?
            object.customer_id : nil
         end.to_s
    controller = ['varieties', 'sizes', 'aspects', 'packagings'].
     include?(controller_name) ? :variants_for_product : controller_name.to_sym
    PERMISSIONS[controller][action_name.to_sym].
     call(self, current_user, id)
  end

  def verify_permission_nested_except_customer(attribute)
    if user_type != "customer"
      verify_permission_nested(attribute)
    else
      verify_permission
    end
  end

  def verify_permission_nested(attribute)
    object = controller_name.classify.
     constantize.find_by_id params[:id]
    user_type_id = user_type + '_id'
    nested_object = object ? object.send(attribute) : nil
    id = (nested_object && nested_object.has_attribute?(user_type_id) ?
          nested_object.send(user_type_id) : nil).to_s
    PERMISSIONS[controller_name.to_sym][action_name.to_sym].
     call(self, current_user, id)
  end

  def extract_locale_from_domain
    if request.domain !~ /localhost/
      parsed_locale = request.domain.match(/[a-z]*\.([a-z.]*)/)[1]
      if parsed_locale == "co.uk" || parsed_locale == "us"
        parsed_locale = "en"
      end
      I18n.available_locales.map(&:to_s).include?(parsed_locale) ?
        parsed_locale.to_s.strip.to_sym : nil
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
end

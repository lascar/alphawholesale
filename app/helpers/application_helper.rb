module ApplicationHelper
  # http://www.socialmemorycomplex.net/2007/09/16/text_field-and-currency-values/
	def monetary_field(objname, method, value)
		text_field "#{objname}", "#{method}", value: ('%0.2f' % value), size: 6,
     class: 'monetary_field', autocomplete: :off
	end

  def resource
    resource_name = request.controller_class.name
    case resource_name
    when 'SuppliersController'
      return current_supplier
    when 'CustomersController'
      return current_customer
    when 'BrokersController'
      return current_broker
    end
  end

  def route_with_locale(locale_string='fr')
    if request.host =~ /localhost/
      request.url.sub(/^http:\/\/(..\.)?/, 'http://' + locale_string + '.')
    else
      if locale_string == 'en'
        locale_string = 'co.uk'
      end
      'http://alphawholesales.' + locale_string
    end
  end

  def current_user_type(user_type)
    (user_type == 'broker' && current_broker) ||
    (user_type == 'supplier' && current_supplier) ||
    (user_type == 'customer' && current_customer)
  end

  def determine_user_type
    (broker_signed_in? && 'broker') ||
      (supplier_signed_in? && 'supplier') ||
      (customer_signed_in? && 'customer') ||
      ''
  end

  def user_logged(user_type)
    case user_type
    when 'supplier'
     user = current_supplier
     path = supplier_path(user)
    when 'customer'
     user = current_customer
     path = customer_path(user)
    when 'broker'
     user = current_broker
     path = broker_path(user)
    end
    identifier = user ? user.identifier : ''
    string = ''
    if !user_type.blank?
      string += <<-HERE
          <li>
            #{link_to t('control_panel'), path, class: 'btn btn-gris btn-sm'}
          </li>
HERE
    end
    string.html_safe
  end
end

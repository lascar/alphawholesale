module ApplicationHelper
  path_products = -> (options:) do
    "/#{options[:pre]}#{options[:post]}products"
  end

  path_product = -> (options:) do
    "/#{options[:pre]}#{options[:post]}products/#{options[:object_id].to_s}"
  end

  path_new_product = -> (options:) do
    "/#{options[:pre]}#{options[:post]}products/new"
  end

  path_edit_product = -> (options:) do
    "/#{options[:pre]}#{options[:post]}products/#{options[:object_id].to_s}/edit"
  end

  path_attached_products = -> (options:) do
      "/#{options[:pre]}#{options[:post]}attached_products"
  end

  path_attached_product = -> (options:) do
    "/#{options[:pre]}#{options[:post]}attached_products/#{options[:object_id].to_s}"
  end

  path_new_attached_product = -> (options:) do
    "/#{options[:pre]}#{options[:post]}attached_products/new"
  end

  path_edit_attached_product = -> (options:) do
    "/#{options[:pre]}#{options[:post]}attached_products/#{options[:object_id].to_s}/edit"
  end

  path_offers = -> (options:) do
    "/#{options[:pre]}#{options[:post]}offers/"
  end

  path_offer = -> (options:) do
    "/#{options[:pre]}#{options[:post]}offers/#{options[:object_id].to_s}"
  end

  path_new_offer = -> (options:) do
    "/#{options[:pre]}#{options[:post]}offers/new"
  end
  
  path_edit_offer = -> (options:) do
    "/#{options[:pre]}#{options[:post]}offers/#{options[:object_id].to_s}/edit"
  end

  path_orders = -> (options:) do
    "/#{options[:pre]}#{options[:post]}orders/"
  end

  path_order = -> (options:) do
    "/#{options[:pre]}#{options[:post]}orders/#{options[:object_id].to_s}"
  end

  path_new_order = -> (options:) do
    "/#{options[:pre]}#{options[:post]}orders/new?offer_id=#{options[:object_id]}"
  end
  
  path_edit_order = -> (options:) do
    "/#{options[:pre]}#{options[:post]}orders/#{options[:object_id].to_s}/edit"
  end

  path_user_products = -> (options:) do
    "/#{options[:post]}user_products/"
  end

  path_user_product = -> (options:) do
    "/#{options[:pre]}#{options[:post]}user_products/#{options[:object_id].to_s}"
  end

  path_new_user_product = -> (options:) do
    "/#{options[:post]}user_products/new"
  end

  path_edit_user_product = -> (options:) do
    "/#{options[:post]}user_products/#{options[:object_id].to_s}/edit"
  end

  path_users = -> (options:) do
    "/#{options[:pre]}#{options[:post]}"
  end

  path_user = -> (options:) do
    "/#{options[:pre]}#{options[:post]}"
  end

  path_new_user = -> (options:) do
    "/#{options[:pre]}#{options[:post]}new"
  end

  path_edit_user = -> (options:) do
    "/#{options[:pre]}#{options[:post]}#{options[:object_id].to_s}/edit"
  end

  path_brokers = -> (options:) do
    "/#{options[:post]}"
  end

  path_broker = -> (options:) do
    "/#{options[:pre]}#{options[:object_id].to_s}"
  end

  path_new_broker = -> (options:) do
    "/#{options[:pre]}new"
  end

  path_edit_broker = -> (options:) do
    "/#{options[:post]}#{options[:object_id].to_s}/edit"
  end

  PATH = {
    path_for_products: path_products,
    path_for_product: path_product,
    path_for_new_product: path_new_product,
    path_for_edit_product: path_edit_product,
    path_for_attached_products: path_attached_products,
    path_for_attached_product: path_attached_product,
      path_for_new_attached_product: path_new_attached_product,
    path_for_offers: path_offers,
    path_for_offer: path_offer,
    path_for_new_offer: path_new_offer,
    path_for_edit_offer: path_edit_offer,
    path_for_orders: path_orders,
    path_for_order: path_order,
    path_for_new_order: path_new_order,
    path_for_edit_order: path_edit_order,
    path_for_user_products: path_user_products,
    path_for_user_product: path_user_product,
    path_for_new_user_product: path_new_user_product,
    path_for_edit_user_product: path_edit_user_product,
    path_for_users: path_users,
    path_for_user: path_user,
    path_for_new_user: path_new_user,
    path_for_edit_user: path_edit_user,
    path_for_brokers: path_brokers,
    path_for_broker: path_broker,
    path_for_new_broker: path_new_broker,
    path_for_edit_broker: path_edit_broker,
  }

  def path_for(user: nil, path: nil, options: {})
    path_for = PATH["path_for_#{path}".to_sym]
    if path_for
      if broker_signed_in? && user.class.name != 'Broker'
        options[:pre] = "brokers/#{current_broker.id.to_s}/"
      end
      if user
        id = user.is_a?(String) ? nil : user.id
        binding.pry if options[:debug]
        options[:post] ="#{user_type(user)}s/#{id ? id.to_s + '/' : ''}"
      end
      path_for.call(options: options)
    end
  end


  # http://www.socialmemorycomplex.net/2007/09/16/text_field-and-currency-values/
  def flag_icon(country_sym)
      "<span class=\"flag-icon flag-icon-#{country_sym.to_s}\"></span>".html_safe
  end

  def icon(class1, class2, *classes)
    clases = "#{class1} #{class2} " + classes.join(' ')
    "<i class=\"#{clases}\"></i>".html_safe
  end

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

  def user_type(user=current_user)
    return user if user.is_a?(String)
    user&.class&.name&.downcase || ''
  end

  def user_logged(user_type)
    string = ''
    if !user_type.blank?
			path = {broker: broker_path(current_user),
							supplier: supplier_path(current_user),
							customer: customer_path(current_user)}
      string += <<-HERE
          <li>
            #{link_to t('views.control_panel'), path, class: 'btn btn-gris btn-sm'}
          </li>
HERE
    end
    string.html_safe
  end

  def helper_activerecord_error_message(attribute, messages)
    message = ''
    messages.keys.each do |key|
      messages[key].each do |error|
        message += I18n.t('models.attributes.' + attribute + '.' + key.to_s) +
                   + ' : ' + error + '<br>'
      end
    end
    message
  end

  def helper_devise_error_message(devise_messages)
    message = ""
    domain = request.path.gsub(/\//, "").singularize
    messages = devise_messages.respond_to?('messages') ?
      devise_messages.messages : []
    messages.each do |key, array|
      message += I18n.t('models.attributes.' + domain +
                        '.' + key.to_s)
      message += " : "
      array.inject(message) do |m, v|
        m += v
        return m
      end
    end
    return message
  end

  def session_destroy_path(user_type)
    path = {broker: destroy_broker_session_path,
            supplier: destroy_supplier_session_path,
            customer: destroy_customer_session_path}
    path[user_type]
  end

  def session_new_path(user_type)
    path = {broker: new_broker_session_path,
            supplier: new_supplier_session_path,
            customer: new_customer_session_path}
    path[user_type]
  end

  def no_session_registration_path(user_type)
    path = {broker: destroy_broker_session_path,
            supplier: destroy_supplier_session_path,
            customer: destroy_customer_session_path}
    path[user_type]
  end
end

module Permissions
  NOT_CUSTOMER_OR_SUPPLIER = -> (current_user, id) do
    !current_user || current_user.class.name == 'Broker'
  end

  SUPPLIER_OWNER = -> (current_user, id) do
    current_user.class.name == 'Supplier' && current_user.id.to_s == id.to_s
  end

  CUSTOMER_OWNER = -> (current_user, id) do
    current_user.class.name == 'Customer' && current_user.id.to_s == id.to_s
  end

  USER = -> (controller, current_user, id) do
  end

  ONLY_BROKER = -> (controller, current_user, id) do
    unless controller.broker_signed_in?
      user_type = current_user.class.name.downcase
      path = '/' + user_type.pluralize + '/' + current_user.id.to_s
      alert = I18n.t('devise.errors.messages.not_authorized')
      controller.redirect_to( path, alert: alert)
      return
    end
  end

  ONLY_SUPPLIER_OR_BROKER = -> (controller, current_user, id) do
    unless current_user.class.name == 'Supplier' || current_user.class.name == 'Broker'
      user_type = current_user.class.name.downcase
      path = '/' + user_type.pluralize + '/' + current_user.id.to_s
      alert = I18n.t('devise.errors.messages.not_authorized')
      controller.redirect_to( path, alert: alert)
      return
    end
  end

  ONLY_CUSTOMER_OR_BROKER = -> (controller, current_user, id) do
    unless current_user.class.name == 'Customer' || current_user.class.name == 'Broker'
      user_type = current_user.class.name.downcase
      path = '/' + user_type.pluralize + '/' + current_user.id.to_s
      alert = I18n.t('devise.errors.messages.not_authorized')
      controller.redirect_to( path, alert: alert)
      return
    end
  end

  ONLY_SUPPLIER_OWNER_OR_BROKER = -> (controller, current_user, id) do
    unless (SUPPLIER_OWNER.call(current_user, id) || current_user.class.name == 'Broker')
      user_type = current_user.class.name.downcase
      path = '/' + user_type.pluralize + '/' + current_user.id.to_s
      alert = I18n.t('devise.errors.messages.not_authorized')
      controller.redirect_to( path, alert: alert)
      return
    end
  end

  ONLY_CUSTOMER_OWNER_OR_BROKER = -> (controller, current_user, id) do
    unless (CUSTOMER_OWNER.call(current_user, id) ||
            current_user.class.name == 'Broker')
      user_type = current_user.class.name.downcase
      path = '/' + user_type.pluralize + '/' + current_user.id.to_s
      alert = I18n.t('devise.errors.messages.not_authorized')
      controller.redirect_to( path, alert: alert)
      return
    end
  end

  ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER = -> (controller, current_user, id) do
    unless (SUPPLIER_OWNER.call(current_user, id) ||
            CUSTOMER_OWNER.call(current_user, id) ||
            current_user.class.name == 'Broker')
      if current_user.nil?
        path = '/'
        alert = I18n.t('devise.failure.unauthenticated')
      else
        user_type = current_user.class.name.downcase
        path = '/' + user_type.pluralize + '/' + current_user.id.to_s
        alert = I18n.t('devise.errors.messages.not_authorized')
      end
      controller.redirect_to( path, alert: alert)
      return
    end
  end

  ONLY_GUEST_OR_BROKER = -> (controller, current_user, id) do
    unless NOT_CUSTOMER_OR_SUPPLIER.call(current_user, id)
      user_type = current_user.class.name.downcase
      path = '/' + user_type.pluralize + '/' + current_user.id.to_s
      alert = I18n.t('devise.errors.messages.not_authorized')
      controller.redirect_to( path, alert: alert)
      return
    end
  end

  PERMISSIONS = {brokers:   {index: ONLY_BROKER,
                             show: ONLY_BROKER,
                             new: ONLY_BROKER,
                             edit: ONLY_BROKER,
                             create: ONLY_BROKER,
                             update: ONLY_BROKER,
                             destroy: ONLY_BROKER},
                suppliers:  {index: ONLY_BROKER,
                             show: ONLY_SUPPLIER_OWNER_OR_BROKER,
                             new: ONLY_BROKER,
                             edit: ONLY_BROKER,
                             create: ONLY_BROKER,
                             update: ONLY_BROKER,
                             destroy: ONLY_BROKER,
                             attach_products: ONLY_SUPPLIER_OWNER_OR_BROKER,
                      attach_products_create: ONLY_SUPPLIER_OWNER_OR_BROKER},
            registrations:  {new: ONLY_GUEST_OR_BROKER,
                             edit: ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER,
                             create: ONLY_GUEST_OR_BROKER,
                             update: ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER,
                             destroy: ONLY_BROKER,
                             cancel: ONLY_BROKER},
                customers:  {index: ONLY_BROKER,
                             show: ONLY_CUSTOMER_OWNER_OR_BROKER,
                             new: ONLY_BROKER,
                             edit: ONLY_CUSTOMER_OWNER_OR_BROKER,
                             create: ONLY_BROKER,
                             update: ONLY_CUSTOMER_OWNER_OR_BROKER,
                             destroy: ONLY_BROKER,
                             attach_products: ONLY_CUSTOMER_OWNER_OR_BROKER,
                      attach_products_create: ONLY_CUSTOMER_OWNER_OR_BROKER},
                 products:   {index: USER,
                              new: ONLY_SUPPLIER_OR_BROKER,
                              show: ONLY_SUPPLIER_OR_BROKER,
                              get_names: ONLY_SUPPLIER_OR_BROKER,
                              edit: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              create: ONLY_SUPPLIER_OR_BROKER,
                              update: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              destroy: ONLY_BROKER},
       variants_for_product: {index: USER,
                              show: USER,
                              new: ONLY_SUPPLIER_OR_BROKER,
                              edit: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              create: ONLY_SUPPLIER_OR_BROKER,
                              update: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              destroy: ONLY_BROKER},
                 offers:     {index: USER,
                              show: USER,
                              new: ONLY_SUPPLIER_OR_BROKER,
                              edit: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              create: ONLY_SUPPLIER_OR_BROKER,
                              update: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              destroy: ONLY_SUPPLIER_OWNER_OR_BROKER},
                 orders:     {index: ONLY_CUSTOMER_OR_BROKER,
                              show: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              new: ONLY_CUSTOMER_OR_BROKER,
                              edit: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              create: ONLY_CUSTOMER_OR_BROKER,
                              update: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              destroy: ONLY_CUSTOMER_OWNER_OR_BROKER},
                tenders:     {index: ONLY_CUSTOMER_OR_BROKER,
                              show: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              new: ONLY_CUSTOMER_OR_BROKER,
                              edit: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              create: ONLY_CUSTOMER_OR_BROKER,
                              update: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              destroy: ONLY_CUSTOMER_OWNER_OR_BROKER},
           tender_lines:     {index: ONLY_CUSTOMER_OR_BROKER,
                              show: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              new: ONLY_CUSTOMER_OR_BROKER,
                              edit: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              create: ONLY_CUSTOMER_OR_BROKER,
                              update: ONLY_CUSTOMER_OWNER_OR_BROKER,
                              destroy: ONLY_CUSTOMER_OWNER_OR_BROKER}
                }
end

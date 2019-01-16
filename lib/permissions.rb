module Permissions
  ANYONE = -> (controller, current_user, id) do
  end

  USER = -> (controller, current_user, id) do
    !!current_user
  end

  ONLY_BROKER = -> (controller, current_user, id) do
    unless controller.broker_signed_in?
      unauthorized(controller, current_user)
    end
  end

  SUPPLIER_OWNER = -> (current_user, id) do
    current_user.class.name == 'Supplier' && current_user.id.to_s == id.to_s
  end

  CUSTOMER_OWNER = -> (current_user, id) do
    current_user.class.name == 'Customer' && current_user.id.to_s == id.to_s
  end

  ONLY_SUPPLIER_OR_BROKER = -> (controller, current_user, id) do
    unless current_user.class.name == 'Supplier' || current_user.class.name == 'Broker'
      unauthorized(controller, current_user)
    end
  end

  ONLY_CUSTOMER_OR_BROKER = -> (controller, current_user, id) do
    unless current_user.class.name == 'Customer' || current_user.class.name == 'Broker'
      unauthorized(controller, current_user)
    end
  end

  ONLY_SUPPLIER_OWNER_OR_BROKER = -> (controller, current_user, id) do
    unless (SUPPLIER_OWNER.call(current_user, id) || current_user.class.name == 'Broker')
      unauthorized(controller, current_user)
    end
  end

  ONLY_CUSTOMER_OWNER_OR_BROKER = -> (controller, current_user, id) do
    unless (CUSTOMER_OWNER.call(current_user, id) ||
            current_user.class.name == 'Broker')
      unauthorized(controller, current_user)
    end
  end

  ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER = -> (controller, current_user, id) do
    unless (SUPPLIER_OWNER.call(current_user, id) ||
            CUSTOMER_OWNER.call(current_user, id) ||
            current_user.class.name == 'Broker')
      unauthorized(controller, current_user)
    end
  end

  ONLY_GUEST_OR_BROKER = -> (controller, current_user, id) do
    unless !current_user || current_user.class.name == 'Broker'
      unauthorized(controller, current_user)
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
                             edit: ONLY_BROKER,
                             create: ONLY_BROKER,
                             update: ONLY_BROKER,
                             destroy: ONLY_BROKER,
                             attach_products: ONLY_CUSTOMER_OWNER_OR_BROKER,
                      attach_products_create: ONLY_CUSTOMER_OWNER_OR_BROKER},
                 products:   {index: ANYONE,
                              new: ONLY_SUPPLIER_OR_BROKER,
                              show: ONLY_SUPPLIER_OR_BROKER,
                              get_names: ONLY_SUPPLIER_OR_BROKER,
                              edit: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              create: ONLY_SUPPLIER_OR_BROKER,
                              update: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              destroy: ONLY_BROKER},
       variants_for_product: {index: ANYONE,
                              show: ANYONE,
                              new: ONLY_SUPPLIER_OR_BROKER,
                              edit: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              create: ONLY_SUPPLIER_OR_BROKER,
                              update: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              destroy: ONLY_BROKER},
                 offers:     {index: ANYONE,
                              show: ANYONE,
                              new: ONLY_SUPPLIER_OR_BROKER,
                              edit: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              create: ONLY_SUPPLIER_OR_BROKER,
                              update: ONLY_SUPPLIER_OWNER_OR_BROKER,
                              destroy: ONLY_SUPPLIER_OWNER_OR_BROKER},
                 orders:     {index: USER,
                              show: ONLY_SUPPLIER_CUSTOMER_OWNER_OR_BROKER,
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

  def self.unauthorized(controller, current_user)
    if current_user
      user_type = current_user.class.name.downcase
      path = '/' + user_type.pluralize + '/' + current_user.id.to_s
      alert = I18n.t('devise.errors.messages.not_authorized')
    else
      path = '/'
      alert = I18n.t('devise.failure.unauthenticated')
    end
    controller.redirect_to( path, alert: alert)
    return
  end
end

class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = root_url
    mail(to: @user.email, subject: I18n.t('mails.welcome.subject'))
  end

  def offer_approval
    offer = params[:offer]
    supplier = offer.supplier
    @product = offer.product_name
    @variety = offer.variety_name
    @aspect = offer.aspect_name
    @packaging = offer.packaging_name
    @size = offer.size_name
    @caliber = offer.caliber_name
    @quantity = offer.quantity
    @unit_price_supplier = offer.unit_price_supplier
    @localisation_supplier = offer.localisation_supplier
    @incoterm = offer.incoterm
    @supplier_observation = offer.supplier_observation
    @date_start = offer.date_start
    @date_end = offer.date_end
    @url  = "#{root_url}/suppliers/#{supplier.id.to_s}/offers/#{offer.id.to_s}"
    mail(to: supplier.email, subject: I18n.t('mails.offer_approval.subject'))
  end

  def order_approval
    order = params[:order]
    customer = order.customer
    @product = order.product_name
    @variety = order.variety_name
    @aspect = order.aspect_name
    @packaging = order.packaging_name
    @size = order.size_name
    @caliber = order.caliber_name
    @quantity = order.quantity
    @unit_price_broker = order.unit_price_broker
    @localisation_broker = order.localisation_broker
    @incoterm = order.incoterm
    @supplier_observation = order.supplier_observation
    @customer_observation = order.customer_observation
    @date_start = order.date_start
    @date_end = order.date_end
    @url  = "#{root_url}/customers/#{customer.id.to_s}/orders/#{order.id.to_s}"
    mail(to: customer.email, subject: I18n.t('mails.order_approval.subject'))
  end

  def object_update
    user = params[:user]
    object = params[:object]
    @object_type = params[:object_type]
    @product = object.product_name
    @variety = object.variety_name
    @aspect = object.aspect_name
    @packaging = object.packaging_name
    @size = object.size_name
    @caliber = object.caliber_name
    @quantity = object.quantity
    if @object_type == 'offer'
      @unit_price_broker = object.unit_price_broker
      @localisation_broker = object.localisation_broker
    else
      @unit_price_supplier = object.unit_price_supplier
      @localisation_supplier = object.localisation_supplier
    end
    @incoterm = object.incoterm
    @supplier_observation = object.supplier_observation
    if @object_type == 'order'
      @supplier_observation = object.supplier_observation
    end
    @date_start = object.date_start
    @date_end = object.date_end
    @url  = "#{root_url}/customers/#{user.id.to_s}/objects/#{object.id.to_s}"
    mail(to: user.email, subject: I18n.t("mails.#{@object_type}_update.subject"))
  end
end

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

  def offer_update
    user = params[:user]
    offer = params[:offer]
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
    @url  = "#{root_url}/customeers/#{user.id.to_s}/offers/#{offer.id.to_s}"
    mail(to: user.email, subject: I18n.t('mails.offer_update.subject'))
  end
end

class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_permission
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  # GET /offers
  def index
    if current_customer
      products = current_customer.products
      @offers = Offer.with_approved(true).select do |offer|
        products.include? offer.product
      end
    elsif current_broker
      @offers = Offer.with_approved(true)
     else
      @supplier_id = current_supplier.id
      @offers = Offer.by_supplier(current_supplier.id)
    end
  end

  # GET /offers/1
  def show
    if supplier_signed_in? && current_supplier.id != @offer.supplier_id
      redirect_to "/suppliers/" + current_supplier.id.to_s,
       alert: I18n.t('devise.errors.messages.not_authorized')
    end
    @supplier_id = customer_signed_in? ? current_customer.id : params[:supplier_id]
  end

  # GET /offers/new
  def new
    @offer = Offer.new
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
      products = Product.all
      @supplier_id = params[:supplier_id]
    else
      products = current_supplier.products
      @supplier_id = @offer.supplier_id = current_supplier.id
    end
    product_names = products.map do |product|
      [product.name, product.id]
    end.uniq
    @products = product_names.inject({}) do |products_hash, product_array|
      product_name = product_array.first
      product_id = product_array.last
      product =
      {"product_id" => product_id,
      "variety" =>
       products.select{|p| p.name == product_name}.first.varieties.map do |variety|
         [variety.name, variety.id]
       end,
      "aspects" =>
       products.select{|p| p.name == product_name}.first.aspects.map do |aspect|
        [aspect.name, aspect.id]
      end,
      "sizes" =>
       products.select{|p| p.name == product_name}.first.sizes.map do |size|
        [size.name, size.id]
      end,
      "packagings" =>
       products.select{|p| p.name == product_name}.first.packagings.map do |packaging|
        [packaging.name, packaging.id]
      end
      }
      products_hash[product_name] = product
      products_hash
    end
    @incoterms = INCOTERMS
    @currencies = CURRENCIES.map do |currency|
      [I18n.t('currencies.' + currency + '.currency') +
       ' (' + I18n.t('currencies.' + currency + '.symbol') + ')',
       currency]
    end
    @unit_types = UNIT_TYPES.map do |unit_type|
      [I18n.t('unit_types.' + unit_type + '.unit_type') +
       ' (' + I18n.t('unit_types.' + unit_type + '.symbol') + ')',
       unit_type]
    end
  end

  # GET /offers/1/edit
  def edit
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
      @supplier_id = params[:supplier_id]
    else
      @supplier_id = @offer.supplier_id = current_supplier.id
    end
    product = @offer.product
    @varieties = product.varieties.map{|v| [v.name, v.id]}
    @aspects = product.aspects.map{|a| [a.name, a.id]}
    @packagings = product.packagings.map{|p| [p.name, p.id]}
    @currencies = CURRENCIES.map do |currency|
    @incoterms = INCOTERMS
      [I18n.t('currencies.' + currency + '.currency') +
       ' (' + I18n.t('currencies.' + currency + '.symbol') + ')',
       currency]
    end
    @unit_types = UNIT_TYPES.map do |unit_type|
      [I18n.t('unit_types.' + unit_type + '.unit_type') +
       ' (' + I18n.t('unit_types.' + unit_type + '.symbol') + ')',
       unit_type]
    end
  end

  # POST /offers
  def create
    @offer = Offer.new(offer_params)
    if supplier_signed_in?
      @offer.supplier_id = current_supplier.id
    end
    if @offer.save
      if supplier_signed_in?
        redirect_to supplier_offer_path(id: @offer.id, supplier_id: @offer.supplier_id), notice: I18n.t('controllers.offers.successfully_created')
      else
        redirect_to offer_path(@offer)
      end
    else
      message = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      path = supplier_signed_in? ?
       new_supplier_offer_path(current_supplier) :
        new_offer_path
      redirect_to path, alert: message
    end
  end

  # PATCH/PUT /offers/1
  def update
    offer_params[:supplier_id] = supplier_signed_in? ? current_supplier.id :
     offer_params[:supplier_id]
    @incoterms = INCOTERMS
    if @offer.update(offer_params)
      if supplier_signed_in?
        redirect_to supplier_offer_path(@offer.supplier_id, @offer), notice: I18n.t('controllers.offers.successfully_updated')
      else
        redirect_to offer_path(@offer), notice: I18n.t('controllers.offers.successfully_updated')
      end
    else
      @offer = Offer.find(params[:id])
      message = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      path = supplier_signed_in? ?
       new_supplier_offer_path(current_supplier) :
        new_offer_path
      redirect_to path, alert: message
    end
  end

  # DELETE /offers/1
  def destroy
    @offer.destroy
    if supplier_signed_in?
      redirect_to supplier_offers_url(supplier_id: current_supplier.id),
        notice: I18n.t('controllers.offers.successfully_destroyed')
    else
      redirect_to offers_url,
        notice: I18n.t('controllers.offers.successfully_destroyed')
    end
  end

  private
	# Use callbacks to share common setup or constraints between actions.
	def set_offer
		offer = Offer.find(params[:id])
    @offer = offer
	end

	# Only allow a trusted parameter "white list" through.
	def offer_params
		if broker_signed_in?
			params.require(:offer).permit(:supplier_id,
                                    :date_start, :date_end,
                                    :quantity, :unit_type, :currency,
																		:unit_price_supplier, :unit_price_broker,
                                    :localisation_supplier,
                                    :localisation_broker,
                                    :observation, :incoterm, :approved,
																		:product_id, :variety_id, :aspect_id,
                                    :size_id, :packaging_id)
		else
			params.require(:offer).permit(:supplier_id,
                                    :date_start, :date_end,
                                    :quantity, :unit_type, :currency,
																		:unit_price_supplier,
                                    :localisation_supplier,
                                    :observation, :incoterm,
																		:product_id, :variety_id, :aspect_id,
                                    :size_id, :packaging_id)
		end
	end
end

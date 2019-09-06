class OffersController < ApplicationController
  include OffersHelper
  include Utilities
  before_action :authenticate_user!
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  # GET /offers
  def index
    authorize :offer, :index?
    offers_raw = Offer.not_expired.includes(:product).includes(:variety)
    offers_raw_with_approved = offers_raw.with_approved(true)
    if current_customer
      offers = offers_raw_with_approved.select do |offer|
        current_customer.products.include? offer.product
      end
    elsif current_broker
      offers = offers_raw_with_approved
    else
      @supplier_id = current_supplier.id
      offers = offers_raw.by_supplier(@supplier_id)
    end
    @offers = map_offers_for_index(offers)
  end

  # GET /offers/1
  def show
    authorize @offer
  end

  # GET /offers/new
  def new
    @offer = Offer.new
    authorize @offer
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
      products = Product.includes(:varieties).includes(:aspects).
        includes(:sizes).includes(:packagings).all
      @supplier_id = params[:supplier_id]
    else
      products = current_supplier.products.includes(:varieties).
        includes(:aspects).includes(:sizes).includes(:packagings)
      @supplier_id = @offer.supplier_id = current_supplier.id
    end
    @products = make_offers_new_products(products)
    @incoterms = INCOTERMS
  end

  # GET /offers/1/edit
  def edit
    authorize @offer
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
    @incoterms = INCOTERMS
  end

  # POST /offers
  def create
    @offer = Offer.new(offer_params)
    authorize @offer
    if supplier_signed_in?
      @offer.supplier_id = current_supplier.id
    end
    if @offer.save
      flash[:notice] = I18n.t('controllers.offers.successfully_created')
      redirect_to offer_show_path(@offer)
    else
      flash[:alert] = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      redirect_to offer_new_path
    end
  end

  # PATCH/PUT /offers/1
  def update
    authorize @offer
    offer_params[:supplier_id] = supplier_signed_in? ? current_supplier.id :
     offer_params[:supplier_id]
    @incoterms = INCOTERMS
    if @offer.update(offer_params)
      flash[:notice] = I18n.t('controllers.offers.successfully_updated')
      redirect_to offer_show_path(@offer)
    else
      @offer = Offer.find(params[:id])
      flash[:alert] = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      redirect_to offer_new_path
    end
  end

  # DELETE /offers/1
  def destroy
    authorize @offer
    @offer.destroy
    flash[:notice] = I18n.t('controllers.offers.successfully_destroyed')
    redirect_to offers_index_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_offer
    offer = Offer.find(params[:id])
    @offer = offer
  end

  # Only allow a trusted parameter "white list" through.
  def offer_params
    base = [:supplier_id, :date_start, :date_end, :quantity,
                   :unit_price_supplier, :localisation_supplier, :observation,
                   :incoterm, :product_id, :variety_id, :aspect_id, :size_id,
                   :packaging_id]
    if broker_signed_in?
      base.push(:unit_price_broker, :localisation_supplier, :approved)
    end
    params.require(:offer).permit(base)
  end

end

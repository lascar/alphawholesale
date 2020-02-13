  class BrokerOffersController < ApplicationController
  include OffersHelper
  include Utilities
  before_action :authenticate_user!
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  # GET /offers
  def index
    lookup_context.prefixes << 'offers'
    @supplier_id = params[:supplier_id]
    @supplier_id = params[:supplier_id]
    @offers = Offer.includes(:attached_product)
    unless params[:approved]
      @offers = @offers.where(approved: true)
    end
    unless params[:expired_too]
      @offers = @offers.not_expired
    end
    if @customer_id
      @offers = @offers.where(attached_product: { id: current_customer.attached_products.pluck(:id) })
    end
    if @supplier_id
      @offers = @offers.where(supplier_id: @supplier_id)
    end
  end

  # GET /offers/1
  def show
    lookup_context.prefixes << 'offers'
    authorize @offer
  end

  # GET /offers/new
  def new
    lookup_context.prefixes << 'offers'
    @offer = Offer.new
    authorize @offer
    @suppliers = Supplier.all.pluck(:identifier, :id)
    products = Product.all
    @supplier_id = params[:supplier_id]
    @attached_products = AttachedProduct.all
    @incoterms = INCOTERMS
  end

  # GET /offers/1/edit
  def edit
    lookup_context.prefixes << 'offers'
    authorize @offer
    @suppliers = Supplier.all.pluck(:identifier, :id)
    @supplier_id = params[:supplier_id]
    product = @offer.product
    @incoterms = INCOTERMS
  end

  # POST /offers
  def create
    params_offer = offer_params
    attached_product = AttachedProduct.find params_offer[:attached_product_id]
    params_offer[:product_id] = Product.find_by_name(attached_product.product).id
    @offer = Offer.new(params_offer)
    authorize @offer
    if @offer.save
      flash[:notice] = I18n.t('controllers.offers.successfully_created')
      redirect_to path_for(user: @offer.supplier, path: 'show_offer')
    else
      flash[:alert] = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      redirect_to path_for(user: @offer.supplier, path: 'new_offer')
    end
  end

  # PATCH/PUT /offers/1
  def update
    authorize @offer
    @incoterms = INCOTERMS
    if @offer.update(offer_params)
      flash[:notice] = I18n.t('controllers.offers.successfully_updated')
      redirect_to path_for(user: @offer.supplier, path: 'show_offer')
    else
      @offer = Offer.find(params[:id])
      flash[:alert] = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      redirect_to path_for(user: @offer.supplier, path: 'new_offer')
    end
  end

  # DELETE /offers/1
  def destroy
    authorize @offer
    @offer.destroy
    flash[:notice] = I18n.t('controllers.offers.successfully_destroyed')
    redirect_to path_for(path: 'offers')
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_offer
    offer = Offer.find(params[:id])
    @offer = offer
  end

  # Only allow a trusted parameter "white list" through.
  def offer_params
    base = [:approved, :supplier_id, :date_start, :date_end, :quantity,
            :unit_price_supplier, :unit_price_broker, :localisation_supplier,
            :localisation_broker, :observation, :incoterm, :attached_product_id]
    params.require(:offer).permit(base)
  end

end

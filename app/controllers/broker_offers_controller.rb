class BrokerOffersController < ApplicationController
  include Utilities
  before_action :set_context_prefixe, except: [:create, :update, :destroy]
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  # GET /offers
  def index
    @supplier_id = params[:supplier_id]
    @customer_id = params[:customer_id]
    @products = set_products
    @offers = Offer.includes(:concrete_product)
    unless params[:not_approved_to]
      @offers = @offers.where(approved: true)
    end
    unless params[:expired_too]
      @offers = @offers.not_expired
    end
    if @customer_id
      @offers = @offers.joins(:orders).where('order.customer_id = ?', @customer_id)
    end
    if @supplier_id
      @offers = @offers.where(supplier_id: @supplier_id)
    end
  end

  # GET /offers/1
  def show
    authorize @offer
    @products = set_products
  end

  # GET /offers/new
  def new
    @offer = Offer.new
    authorize @offer
    regexp = /\A[0-9A-Za-z_-]*\z/
    @product = Product.find_by(name: new_offer_params[:product].scan(regexp).first)
    @suppliers = Supplier.all.pluck(:identifier, :id)
    @supplier_id = params[:supplier_id]
    @concrete_products = ConcreteProduct.all
    @incoterms = INCOTERMS
  end

  # GET /offers/1/edit
  def edit
    authorize @offer
    @suppliers = Supplier.all.pluck(:identifier, :id)
    @supplier_id = params[:supplier_id]
    @incoterms = INCOTERMS
  end

  # POST /offers
  def create
    params_offer = offer_params
    params_offer.delete("concrete_product")
    @offer = Offer.new(params_offer)
    authorize @offer
    concrete_product = ConcreteProduct.find_or_create_by (offer_params["concrete_product"])
    @offer.concrete_product = concrete_product
    if @offer.save
      flash[:notice] = I18n.t('controllers.offers.successfully_created')
      redirect_to path_for(user: @offer.supplier, path: 'offer', options: {object_id: @offer.id})
    else
      flash[:alert] = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      redirect_to path_for( path: 'new_offer'), product: concrete_product.product
    end
  end

  # PATCH/PUT /offers/1
  def update
    authorize @offer
    @incoterms = INCOTERMS
    if @offer.update(offer_params)
      flash[:notice] = I18n.t('controllers.offers.successfully_updated')
      redirect_to path_for(user: @offer.supplier, path: 'offer', options: {object_id: @offer.id})
    else
      @offer = Offer.find(params[:id])
      flash[:alert] = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      redirect_to path_for(path: 'offers')
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
  def set_products
    products = Product.pluck(:name)
    products.map{|product| [I18n.t('products.' + (product).to_s + '.name'), product]}
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_context_prefixe
    lookup_context.prefixes << 'offers'
  end

  def set_offer
    offer = Offer.find(params[:id])
    @offer = offer
  end

  # Only allow a trusted parameter "white list" through.
  def new_offer_params
    base = [:product]
    params.require(:new_offer).permit(base)
  end

  def offer_params
    base = [:supplier_id, :date_start, :date_end, :quantity,:incoterm,
            :unit_price_supplier, :localisation_supplier, :supplier_observation,
            :approved, :unit_price_broker, :localisation_broker,
            concrete_product: [:product, :variety, :aspect, :packaging, :size, :caliber]]
    params.require(:offer).permit(base)
  end

end

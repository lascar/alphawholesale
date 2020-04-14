class OffersController < ApplicationController
  include Utilities
  before_action :authenticate_user!
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  # GET /offers
  def index
    supplier = current_supplier
    @offers = Offer.includes(:concrete_product).not_expired
    if current_customer
      @offers = @offers.where(approved: true).
        where(concrete_products: { id: current_customer.concrete_products.pluck(:id) })
    end
    if supplier
      @products = set_supplier_products(supplier)
      @offers = @offers.where(supplier_id: supplier.id)
    end
  end

  # GET /offers/1
  def show
    authorize @offer
    if current_supplier
      @products = set_supplier_products(current_supplier)
    end
  end

  # GET /offers/new
  def new
    regexp = /\A[0-9A-Za-z_-]*\z/
    @offer = Offer.new
    authorize @offer
    @supplier_id = @offer.supplier_id = current_supplier.id
    @product = Product.find_by(name: params_new[:product].scan(regexp).first)
    @concrete_products = UserConcreteProduct.
      where(user_type: "Supplier", user_id: @supplier_id).
      select do |user_concrete_product|
        user_concrete_product.concrete_product.product == @product.name
      end.map do |user_concrete_product|
        ConcreteProduct.find_by(id: user_concrete_product.concrete_product_id)
    end.uniq.flatten
    @incoterms = INCOTERMS
  end

  # GET /offers/1/edit
  def edit
    authorize @offer
    @supplier_id = @offer.supplier_id = current_supplier.id
    @incoterms = INCOTERMS
  end

  # POST /offers
  def create
    params_offer = offer_params
    params_offer.delete("new_concrete_product")
    params_offer.delete("concrete_product")
    @offer = Offer.new(params_offer)
    authorize @offer
    @offer.supplier_id = current_supplier.id
    if offer_params["concrete_product_id"] == '0'
      concrete_product = ConcreteProduct.find_or_create_by (offer_params["new_concrete_product"])
    else
      concrete_product = ConcreteProduct.find (offer_params["concrete_product_id"])
    end
    @offer.concrete_product = concrete_product
    begin
      current_supplier.concrete_products << concrete_product
    rescue; end
    if @offer.save
      flash[:notice] = I18n.t('controllers.offers.successfully_created')
      redirect_to path_for(user: @offer.supplier, path: 'offer',
                           options: {object_id: @offer.id})
    else
      flash[:alert] = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      redirect_to path_for(user: @offer.supplier, path: 'new_offer')
    end
  end

  # PATCH/PUT /offers/1
  def update
    authorize @offer
    offer_params[:supplier_id] = supplier_signed_in? ? current_supplier.id :
     offer_params[:supplier_id]
    @supplier = @offer.supplier
    @incoterms = INCOTERMS
    if @offer.update(offer_params)
      flash[:notice] = I18n.t('controllers.offers.successfully_updated')
      redirect_to path_for(user: @supplier, path: 'offer', options: {object_id: @offer.id})
    else
      @offer = Offer.find(params[:id])
      flash[:alert] = helper_activerecord_error_message('offer',
                                                  @offer.errors.messages)
      redirect_to path_for(user: @supplier, path: 'edit_offer', options: {object_id: @offer.id})
    end
  end

  # DELETE /offers/1
  def destroy
    authorize @offer
    supplier = @offer.supplier
    @offer.destroy
    flash[:notice] = I18n.t('controllers.offers.successfully_destroyed')
    redirect_to path_for(user: supplier, path: 'offers')
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_offer
    if params[:id] == 'new'
      render status: 404
      return
    end
    offer = Offer.find(params[:id])
    @offer = offer
  end

  def set_supplier_products(supplier)
    products = supplier.products.pluck(:name)
    products.map{|product| [I18n.t('products.' + (product).to_s + '.name'), product]}
  end


  # Only allow a trusted parameter "white list" through.
  def params_new
    base = [:product]
    params.require(:new_offer).permit(base)
  end

  def offer_params
    base = [:date_start, :date_end, :quantity,:incoterm,
            :unit_price_supplier, :localisation_supplier, :supplier_observation,
            :concrete_product_id,
            new_concrete_product: [:product, :variety, :aspect, :packaging, :size, :caliber]]
    params.require(:offer).permit(base)
  end
end

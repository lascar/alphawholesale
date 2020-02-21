class OffersController < ApplicationController
  include Utilities
  before_action :authenticate_user!
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  # GET /offers
  def index
    @supplier_id = current_supplier&.id || params[:supplier_id]
    @offers = Offer.includes(:attached_product).not_expired
    if current_customer
      @offers = @offers.where(approved: true).
        where(attached_products: { id: current_customer.attached_products.pluck(:id) })
    end
    if @supplier_id
      @offers = @offers.where(supplier_id: @supplier_id)
    end
  end

  # GET /offers/1
  def show
    authorize @offer
  end

  # GET /offers/new
  def new
    @offer = Offer.new
    authorize @offer
    @supplier_id = @offer.supplier_id = current_supplier.id
    attached_products = current_supplier.attached_products
    @attached_products = attached_products
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
    @offer = Offer.new(offer_params)
    authorize @offer
    @offer.supplier_id = current_supplier.id
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

  # Only allow a trusted parameter "white list" through.
  def offer_params
    base = [:supplier_id, :date_start, :date_end, :quantity,
                   :unit_price_supplier, :localisation_supplier, :observation,
                   :incoterm, :attached_product_id]
    params.require(:offer).permit(base)
  end
end

class BrokerRequestsController < ApplicationController
  include Utilities
  before_action :set_context_prefixe, except: [:create, :update, :destroy]
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests
  def index
    @supplier_id = params[:supplier_id]
    @customer_id = params[:customer_id]
    @products = set_products
    @requests = Request.includes(:concrete_product)
    unless params[:not_approved_to]
      @requests = @requests.where(approved: true)
    end
    unless params[:expired_too]
      @requests = @requests.not_expired
    end
    # if @supplier_id
    #   @requests = @requests.joins(:responses).where('response.supplier_id = ?', @supplier_id)
    # end
    if @customer_id
      @requests = @requests.where(customer_id: @customer_id)
    end
  end

  # GET /requests/1
  def show
    authorize @request
    @products = set_products
  end

  # GET /requests/new
  def new
    @request = Request.new
    authorize @request
    regexp = /\A[0-9A-Za-z_-]*\z/
    @product = Product.find_by(name: new_request_params[:product].scan(regexp).first)
    @customers = Customer.all.pluck(:identifier, :id)
    @customer_id = params[:customer_id]
    @concrete_products = ConcreteProduct.all
  end

  # GET /requests/1/edit
  def edit
    authorize @request
    @customers = Customer.all.pluck(:identifier, :id)
    @customer_id = params[:customer_id]
  end

  # POST /requests
  def create
    params_request = request_params
    params_request.delete("concrete_product")
    @request = Request.new(params_request)
    authorize @request
    concrete_product = ConcreteProduct.find_or_create_by (request_params["concrete_product"])
    @request.concrete_product = concrete_product
    if @request.save
      flash[:notice] = I18n.t('controllers.requests.successfully_created')
      redirect_to path_for(user: @request.customer, path: 'request', options: {object_id: @request.id})
    else
      flash[:alert] = helper_activerecord_error_message('request',
                                                  @request.errors.messages)
      redirect_to path_for( path: 'new_request'), product: concrete_product.product
    end
  end

  # PATCH/PUT /requests/1
  def update
    authorize @request
    if @request.update(request_params)
      flash[:notice] = I18n.t('controllers.requests.successfully_updated')
      redirect_to path_for(user: @request.customer, path: 'request', options: {object_id: @request.id})
    else
      @request = Request.find(params[:id])
      flash[:alert] = helper_activerecord_error_message('request',
                                                  @request.errors.messages)
      redirect_to path_for(path: 'requests')
    end
  end

  # DELETE /requests/1
  def destroy
    authorize @request
    @request.destroy
    flash[:notice] = I18n.t('controllers.requests.successfully_destroyed')
    redirect_to path_for(path: 'requests')
  end

  private
  def set_products
    products = Product.pluck(:name)
    products.map{|product| [I18n.t('products.' + (product).to_s + '.name'), product]}
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_context_prefixe
    lookup_context.prefixes << 'requests'
  end

  def set_request
    request = Request.find(params[:id])
    @request = request
  end

  # Only allow a trusted parameter "white list" through.
  def new_request_params
    base = [:product]
    params.require(:new_request).permit(base)
  end

  def request_params
    base = [:customer_id, :date_start, :date_end, :quantity, :customer_observation,
            :approved,
            concrete_product: [:product, :variety, :aspect, :packaging, :size, :caliber]]
    params.require(:request).permit(base)
  end

end

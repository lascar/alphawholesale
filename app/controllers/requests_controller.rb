class RequestsController < ApplicationController
  include Utilities
  before_action :authenticate_user!
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  # GET /requests
  def index
    @requests = Request.includes(:concrete_product).not_expired
    customer = current_customer
    supplier = current_supplier
    if supplier
      @requests = @requests.where(approved: true).
        where(concrete_products: { id: supplier.concrete_products.pluck(:id) })
    end
    if customer
      @products = set_customer_products(customer)
      @requests = @requests.where(customer_id: customer.id)
    end
  end

  # GET /requests/1
  def show
    authorize @request
    @customer = @request.customer
    @customers = [[@customer.identifier, @customer.id]]
  end

  # GET /requests/new
  def new
    regexp = /\A[0-9A-Za-z_-]*\z/
    @request = Request.new
    authorize @request
    @customer = current_customer
    @customers = [[@customer.identifier, @customer.id]]
    @product = Product.find_by(name: params_new[:product].scan(regexp).first)
    @concrete_products = UserConcreteProduct.
      where(user_type: "Customer", user_id: @customer_id).
      select do |user_concrete_product|
        user_concrete_product.concrete_product.product == @product.name
      end.map do |user_concrete_product|
        ConcreteProduct.find_by(id: user_concrete_product.concrete_product_id)
    end.uniq.flatten
  end

  # GET /requests/1/edit
  def edit
    authorize @request
    @customer = current_customer
    @customers = [[@customer.identifier, @customer.id]]
  end

  # POST /requests
  def create
    params_request = request_params
    params_request.delete("concrete_product")
    @request = Request.new(params_request)
    authorize @request
    @request.customer_id = current_customer.id
    concrete_product = ConcreteProduct.find_or_create_by (request_params["concrete_product"])
    @request.concrete_product = concrete_product
    if @request.save
      flash[:notice] = I18n.t('controllers.requests.successfully_created')
      redirect_to path_for(user: @request.customer, path: 'request',
                           options: {object_id: @request.id})
    else
      flash[:alert] = helper_activerecord_error_message('request',
                                                  @request.errors.messages)
      redirect_to path_for(user: @request.customer, path: 'new_request')
    end
  end

  # PATCH/PUT /requests/1
  def update
    authorize @request
    request_params[:customer_id] = customer_signed_in? ? current_customer.id :
     request_params[:customer_id]
    @customer = @request.customer
    if @request.update(request_params)
      flash[:notice] = I18n.t('controllers.requests.successfully_updated')
      redirect_to path_for(user: @customer, path: 'request', options: {object_id: @request.id})
    else
      @request = Request.find(params[:id])
      flash[:alert] = helper_activerecord_error_message('request',
                                                  @request.errors.messages)
      redirect_to path_for(user: @customer, path: 'edit_request', options: {object_id: @request.id})
    end
  end

  # DELETE /requests/1
  def destroy
    authorize @request
    @request.destroy
    flash[:notice] = I18n.t('controllers.requests.successfully_destroyed')
    redirect_to path_for(user: @request.customer, path: 'requests')
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_request
    if params[:id] == 'new'
      render status: 404
      return
    end
    request = Request.find(params[:id])
    @request = request
  end

  def set_customer_products(customer)
    products = customer.products.pluck(:name)
    products.map{|product| [I18n.t('products.' + (product).to_s + '.name'), product]}
  end


  # Only allow a trusted parameter "white list" through.
  def params_new
    base = [:product]
    params.require(:new_request).permit(base)
  end

  def request_params
    base = [:date_start, :date_end, :quantity, :customer_observation,
            concrete_product: [:product, :variety, :aspect, :packaging, :size, :caliber]]
    params.require(:request).permit(base)
  end
end

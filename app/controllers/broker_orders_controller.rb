class BrokerOrdersController < ApplicationController
  before_action :set_context_prefixe, except: [:create, :update, :destroy]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  def index
    lookup_context.prefixes << 'orders'
    @customer_id = params[:customer_id]
    @supplier_id = params[:supplier_id]
    @orders = Order.includes(:offer)
    if @customer_id
      @orders = @order.where(customer_id: @customer_id)
    end
    if @supplier_id
      @orders = @orders.joins(:offer).where('offers.supplier_id = ?', @supplier_id)
    end
    unless params[:not_approved_too]
      @orders = @orders.where(approved: true)
    end
    unless params[:expired_too]
      @orders = @orders.not_expired
    end
  end

  # GET /orders/1
  def show
    lookup_context.prefixes << 'orders'
    authorize @order
    @offer = @order.offer
    @customer_id = customer_signed_in? ? current_customer.id : params[:customer_id]
  end

  # GET /orders/new
  def new
    customer_id = customer_signed_in? ? current_customer.id :
     params['customer_id']
    @customers = Customer.all.pluck(:identifier, :id)
    @offer = Offer.find(params[:offer_id])
    @order = Order.new(customer_id: customer_id, offer_id: @offer.id)
    authorize @order
  end

  # GET /orders/1/edit
  def edit
    authorize @order
    @customers = Customer.all.pluck(:identifier, :id)
    @customer_id = @order.customer_id
    @offer = @order.offer
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.customer_id = customer_signed_in? ? current_customer.id :
      order_params['customer_id']
    if @order.save
      flash[:notice] = I18n.t('controllers.orders.successfully_created')
      redirect_to path_for(path: 'order', options: {object_id: @order.id})
      return
    else
      flash[:alert] = helper_activerecord_error_message('order', @order.errors.messages)
      redirect_to path_for(path: 'new_order')
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      flash[:notice] = I18n.t('controllers.orders.successfully_updated')
      redirect_to path_for(path: 'order', options: {object_id: @order.id})
      return
    else
      flash[:alert] = helper_activerecord_error_message('order', @order.errors.messages)
      redirect_to path_for(user: @user, path: 'edit_order', options: {object_id: @order.id})
    end
  end

  # DELETE /orders/1
  def destroy
    authorize @order
    @order.destroy
    flash[:notice] = I18n.t('controllers.orders.successfully_destroyed')
    redirect_to path_for(user: @user, path: 'orders')
  end

  private
  def set_context_prefixe
    lookup_context.prefixes << 'orders'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    base = [:customer_id, :offer_id, :quantity, :customer_observation, :approved]
    params.require(:order).permit(base)
  end

end

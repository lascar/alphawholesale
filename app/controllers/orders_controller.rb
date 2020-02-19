class OrdersController < ApplicationController
  include Utilities
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  def index
    authorize :order, :index?
    @orders = Order.includes(:offer)
    if customer_signed_in?
      @customer_id = current_customer.id
      @orders = @orders.where(customer_id: @customer_id)
    elsif supplier_signed_in?
      @supplier_id = current_supplier.id
      @orders = @orders.where('offers.supplier_id = ?', @supplier_id)
    end
    unless params[:expired_too]
      @orders = @orders.not_expired
    end
  end

  # GET /orders/1
  def show
    authorize @order
    @offer = @order.offer
    @customer_id = customer_signed_in? ? current_customer.id : params[:customer_id]
  end

  # GET /orders/new
  def new
    customer_id = customer_signed_in? ? current_customer.id :
     params['customer_id']
    if broker_signed_in?
      @customers = Customer.all.pluck(:identifier, :id)
    end
    @offer = Offer.find(params[:offer_id])
    @offer_nested = make_offer_nested(@offer)
    @order = Order.new(customer_id: customer_id, offer_id: @offer.id)
    authorize @order
  end

  # GET /orders/1/edit
  def edit
    authorize @order
    @customer_id = @order.customer_id
    @order.customer_id = @customer_id
    @offer = @order.offer
    @offer_nested = make_offer_nested(@offer)
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    authorize @order
    @order.customer_id = customer_signed_in? ? current_customer.id :
      order_params['customer_id']
    if @order.save
      flash[:notice] = I18n.t('controllers.orders.successfully_created')
      redirect_to path_for(user: @user, path: 'order', options: {object_id: @order.id})
    else
      flash[:alert] = helper_activerecord_error_message('order', @order.errors.messages)
      redirect_to path_for(user: @user, path: 'new_order', options: {object_id: order_params[:offer_id]})
    end
  end

  # PATCH/PUT /orders/1
  def update
    authorize @order
    if @order.update(order_params)
      flash[:notice] = I18n.t('controllers.orders.successfully_updated')
      redirect_to path_for(user: @user, path: 'order', options: {object_id: order_params[:offer_id]})
    else
      flash[:alert] = helper_activerecord_error_message('order', @order.errors.messages)
      redirect_to path_for(user: @user, path: 'edit_order', options: {object_id: order_params[:offer_id]})
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
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    base = [:customer_id, :offer_id, :quantity, :customer_observation]
    params.require(:order).permit(base)
  end

end

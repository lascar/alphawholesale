class OrdersController < ApplicationController
  include Utilities
  include OrdersHelper
  before_action :authenticate_user!
  before_action :verify_permission, except: [:show]
  before_action only: [:show] do
    verify_permission_nested("offer", "customer")
  end
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  def index
    if current_broker
      orders = Order.with_approved(true).includes(:offer)
    elsif customer_signed_in?
      @customer_id = current_customer.id
      orders = Order.where(customer_id: @customer_id).includes(:offer)
    elsif supplier_signed_in?
      @supplier_id = current_supplier.id
      orders = Order.joins(:offer).where('offers.supplier_id = ?', @supplier_id).
        with_approved(true).includes(:offer)
    end
    @orders = map_orders_for_index(orders)
  end

  # GET /orders/1
  def show
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
  end

  # GET /orders/1/edit
  def edit
    if broker_signed_in?
      @customers = Customer.all.pluck(:identifier, :id)
    end
    @customer_id = @order.customer_id
    @order.customer_id = @customer_id
    @offer = @order.offer
    @offer_nested = make_offer_nested(@offer)
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @order.customer_id = customer_signed_in? ? current_customer.id :
      order_params['customer_id']
    if @order.save
      flash[:notice] = I18n.t('controllers.orders.successfully_created')
      redirect_to order_show_path(@order)
    else
      flash[:alert] = helper_activerecord_error_message('order', @order.errors.messages)
      redirect_to order_new_path(order_params[:offer_id])
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      flash[:notice] = I18n.t('controllers.orders.successfully_updated')
      redirect_to order_show_path
    else
      flash[:alert] = helper_activerecord_error_message('order', @order.errors.messages)
      redirect_to order_edit_path
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    flash[:notice] = I18n.t('controllers.orders.successfully_destroyed')
    redirect_to order_index_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    base = [:customer_id, :offer_id, :quantity, :customer_observation]
    if broker_signed_in?
      base.push(:approved)
    end
    params.require(:order).permit(base)
  end

end

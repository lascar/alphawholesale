class OrdersController < ApplicationController
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
      orders = Order.where(customer_id: current_customer.id).includes(:offer)
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
    @customer_id = customer_signed_in? ? current_customer.id :
     params['customer_id']
    if broker_signed_in?
      @customers = Customer.all.pluck(:identifier, :id)
    end
    @offer = Offer.find(params[:offer_id])
    @order = Order.new(customer_id: @customer_id, offer_id: @offer.id)
  end

  # GET /orders/1/edit
  def edit
    if broker_signed_in?
      @customers = Customer.all.pluck(:identifier, :id)
    end
    @customer_id = @order.customer_id
    @order.customer_id = @customer_id
    @offer = @order.offer
  end

  # POST /orders
  def create
    @order = Order.new(order_params)
    @customer_id = customer_signed_in? ? current_customer.id : order_params['customer_id']
    @order.customer_id = @customer_id
    if @order.save
      flash[:notice] = I18n.t('controllers.orders.successfully_created')
      if customer_signed_in?
        redirect_to customer_order_path(id: @order.id, customer_id: @customer_id)
      else
        redirect_to order_path(@order)
      end
    else
      message = ''
      @order.errors.messages.each do |k,v|
        message += I18n.t('activerecord.attributes.order.' + k.to_s) +
         ' : ' + v.inject(''){|s, m| s += m + " "}
      end
      flash[:alert] = message
      if customer_signed_in?
        redirect_to new_customer_order_path(current_customer.id,
                                            offer_id: order_params[:offer_id])
      else
        redirect_to new_order_path(offer_id: order_params[:offer_id])
      end
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      if customer_signed_in?
        redirect_to customer_order_path(@order.customer_id, @order), notice: I18n.t('controllers.orders.successfully_updated')
      else
        redirect_to order_path(@order), notice: I18n.t('controllers.orders.successfully_updated')
      end
    else
      @order = Order.find(params[:id])
      @customer_id = @order.customer_id
      if broker_signed_in?
        @customers = Customer.all.pluck(:identifier, :id)
      end
      render :edit
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
    if customer_signed_in?
      redirect_to customer_orders_url(customer_id: current_customer.id),
        notice: I18n.t('controllers.orders.successfully_destroyed')
    else
      redirect_to orders_url,
        notice: I18n.t('controllers.orders.successfully_destroyed')
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def order_params
    if broker_signed_in?
      params.require(:order).permit(:customer_id, :offer_id, :quantity,
                                  :customer_observation, :approved)
    else
      params.require(:order).permit(:quantity, :offer_id, :customer_observation)
    end
  end

  def map_orders_for_index(orders)
    orders.map do |order|
      {id: order.id, product_name: order.offer.product.name,
       quantity: order.quantity.to_s + ' ' +
       I18n.t('unit_types.' + order.offer.supplier.unit_type + '.symbol')}
    end
  end

end

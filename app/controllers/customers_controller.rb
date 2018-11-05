class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_permission_user
  before_action :set_customer, only: [:show, :edit, :update, :destroy,
                                      :attach_products, :attach_products_create]

  # GET /customers
  def index
    @customers = Customer.with_approved(true)
  end

  # GET /customers/1
  def show
    @orders = @customer.orders
    @products = @customer.products
    @offers = Offer.where(approved: true).select{|o| o.date_end >= Time.now}
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to @customer, notice: I18n.t('controllers.customers.successfully_created')
    else
      render :new
    end
  end

  # PATCH/PUT /customers/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer,
       notice: I18n.t('controllers.customers.successfully_updated')
    else
      render :edit
    end
  end

  # DELETE /customers/1
  def destroy
    @customer.destroy
    redirect_to customers_url,
     notice: I18n.t('controllers.customers.successfully_destroyed')
  end

  # GET /customers/1/attach_product
  def attach_products
    @products_attached = @customer.products.ids
    @products = Product.with_approved(true).
     select{|p| !@products_attached.include?(p.id)}
  end

  # POST /customers/1/attach_product_create
  def attach_products_create
    message = ""
    @customer.products = []
    params[:products].each do |product_id|
      product = Product.find_by_id(product_id)
      @customer.products << product
    end
    redirect_to "/customers/" + @customer.id.to_s, notice: message
  end

 private
  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def customer_params
    if current_broker
      params.require(:customer).permit(:identifier, :email, :approved,
                                       :tin, :street_and_number, :postal_code,
                                       :state, :country, :entreprise_name,
                                       :telephone_number1, :telephone_number2,
                                       :password, :password_confirmation)
    else
      if !params[:customer][:current_password].blank? &&
       @customer.valid_password?(params[:customer][:current_password])
        params.require(:customer).permit(:email,
                                         :tin, :street_and_number, :postal_code,
                                         :state, :country, :entreprise_name,
                                         :telephone_number1, :telephone_number2,
                                         :password, :password_confirmation)
      else
        params.require(:customer).permit(:email,
                                         :tin, :street_and_number, :postal_code,
                                         :state, :country, :entreprise_name,
                                         :telephone_number1, :telephone_number2)
      end
    end
  end
end

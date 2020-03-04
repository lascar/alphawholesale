class CustomersController < ApplicationController
  include Utilities
  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  def index
    authorize :customer, :index?
    @customers = Customer.with_approved(true)
  end

  # GET /customers/1
  def show
    authorize @customer
    @orders = @customer.orders
    @attached_products = @customer.attached_products
    @offers = Offer.where(approved: true).select{|o| o.date_end >= Time.now}
    @user_products = @customer.products
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    authorize @customer
    @currencies, @unit_types = put_currencies_unit_types
    redirect_to new_customer_registration_path
  end

  # GET /customers/1/edit
  def edit
    authorize @customer
    @currencies, @unit_types = put_currencies_unit_types
    @minimum_password_length = PASSWORD_LENGTH_MIN
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)
    authorize @customer
    if @customer.save
      redirect_to @customer,
       notice: I18n.t('controllers.customers.successfully_created')
    else
      flash[:alert] = helper_activerecord_error_message('customer',
                                                  @customer.errors.messages)
      redirect_to path_for(user: @user, path: 'new_customer')
    end
  end

  # PATCH/PUT /customers/1
  def update
    authorize @customer
    if @customer.update(customer_params)
      if customer_params[:approved]
        SupplierMailer.with(user: @customer).welcome_email.deliver_later
      end
      redirect_to @customer,
       notice: I18n.t('controllers.customers.successfully_updated') and return
    else
      flash[:alert] = helper_activerecord_error_message('customer',
                                                  @customer.errors.messages)
      redirect_to path_for(user: @user, path: 'edit_customer')
    end
  end

  # DELETE /customers/1
  def destroy
    authorize @customer
    @customer.destroy
    redirect_to path_for(user: 'customer', path: 'users'),
     notice: I18n.t('controllers.customers.successfully_destroyed')
  end

 private
  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find_by(id: params[:id] || params[:customer_id])
  end

  # Only allow a trusted parameter "white list" through.
  def customer_params
    base = [:email, :tin, :street_and_number, :postal_code, :state, :country,
            :entreprise_name, :telephone_number1, :telephone_number2,
            :unit_type, :currency]
    current_password = params[:customer][:current_password]
    if current_broker
      base.push(:identifier, :approved, :password, :password_confirmation)
    elsif !current_password.blank? && @customer.valid_password?(current_password)
      base.push(:password, :password_confirmation)
    end
    params.require(:customer).permit(base)
  end

end

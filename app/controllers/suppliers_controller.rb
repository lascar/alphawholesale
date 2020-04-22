class SuppliersController < ApplicationController
  include Utilities
  before_action :authenticate_user!
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  # GET /suppliers
  def index
    authorize :supplier, :index?
    @suppliers = Supplier.with_approved(true)
  end

  # GET /suppliers/1
  def show
    authorize @supplier
    @concrete_products = @supplier.concrete_products
    @user_products = @supplier.products
    @offers = @supplier.offers.includes(:orders, :concrete_product).
      where(approved: true).not_expired
    @orders = @offers.map{|offer| offer.orders.where(approved: true)}.compact.flatten
    @requests = Request.not_expired.where(approved: true).includes( :concrete_product).
      where(concrete_products: { product: @user_products.pluck(:name)})
    @responses = @supplier.responses.not_expired
  end

  # GET /suppliers/new
  def new
    @currencies, @unit_types = put_currencies_unit_types
    @supplier = Supplier.new
    authorize @supplier
    redirect_to new_supplier_registration_path
  end

  # GET /suppliers/1/edit
  def edit
    authorize @supplier
    @currencies, @unit_types = put_currencies_unit_types
    @minimum_password_length = PASSWORD_LENGTH_MIN
  end

  # POST /suppliers
  def create
    @supplier = Supplier.new(supplier_params)
    authorize @supplier

    if @supplier.save
      redirect_to @supplier,
       notice: I18n.t('controllers.suppliers.successfully_created')
    else
      flash[:alert] = helper_activerecord_error_message('supplier',
                                                  @supplier.errors.messages)
      redirect_to path_for(user: @user, path: 'new_supplier')
    end
  end

  # PATCH/PUT /suppliers/1
  def update
    authorize @supplier
    if @supplier.update(supplier_params)
      redirect_to( path_for(user: @supplier, path: 'user'),
       notice: I18n.t('controllers.suppliers.successfully_updated')) and return
    else
      flash[:alert] = helper_activerecord_error_message('supplier',
                                                  @supplier.errors.messages)
      redirect_to path_for(user: @user, path: 'edit_supplier')
    end
  end

  # DELETE /suppliers/1
  def destroy
    authorize @supplier
    @supplier.destroy
    redirect_to suppliers_url,
     notice: I18n.t('controllers.suppliers.successfully_destroyed')
  end

  private
  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def supplier_params
    base = [:email, :tin, :street_and_number, :postal_code, :city, :state, :country,
            :entreprise_name, :telephone_number1, :telephone_number2,
            :unit_type, :currency]
    current_password = params[:supplier][:current_password]
    if current_broker
      if params[:password].blank?
        base.push(:identifier, :approved)
      else
        base.push(:identifier, :approved, :password, :password_confirmation)
      end
    elsif !current_password.blank? && @supplier.valid_password?(current_password)
      base.push(:password, :password_confirmation)
    end
    params.require(:supplier).permit(base)
  end

end

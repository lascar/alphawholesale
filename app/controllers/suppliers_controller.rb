class SuppliersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_permission_user
  before_action :set_supplier,
   only: [:show, :edit, :update, :destroy,
          :attach_products, :attach_products_create]

  # GET /suppliers
  def index
    @suppliers = Supplier.with_approved(true)
  end

  # GET /suppliers/1
  def show
    @offers = @supplier.offers
    @products = @supplier.products
  end

  # GET /suppliers/new
  def new
    @currencies, @unit_types = put_currencies_unit_types
    @supplier = Supplier.new
    redirect_to new_supplier_registration_path
  end

  # GET /suppliers/1/edit
  def edit
    @currencies, @unit_types = put_currencies_unit_types
    @minimum_password_length = PASSWORD_LENGTH_MIN
  end

  # POST /suppliers
  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      redirect_to @supplier,
       notice: I18n.t('controllers.suppliers.successfully_created')
    else
        @currencies, @unit_types = put_currencies_unit_types
      render :new
    end
  end

  # PATCH/PUT /suppliers/1
  def update
    if @supplier.update(supplier_params)
      if supplier_params[:approved]
        SupplierMailer.with(user: @supplier).welcome_email.deliver_later
      end
      redirect_to( @supplier,
       notice: I18n.t('controllers.suppliers.successfully_updated')) and return
    else
      @currencies, @unit_types = put_currencies_unit_types
      @minimum_password_length = PASSWORD_LENGTH_MIN
      render :edit
    end
  end

  # DELETE /suppliers/1
  def destroy
    @supplier.destroy
    redirect_to suppliers_url,
     notice: I18n.t('controllers.suppliers.successfully_destroyed')
  end

  # GET /suppliers/1/attach_product
  def attach_products
    @products_attached = @supplier.products.ids
    @products = Product.with_approved(true) +
     Product.where(supplier_id: @supplier.id, approved: false)
  end

  # POST /suppliers/1/attach_product_create
  def attach_products_create
    message = ""
    @supplier.products = []
    params[:products].each do |product_id|
      product = Product.find_by_id(product_id)
      @supplier.products << product
    end
    redirect_to "/suppliers/" + @supplier.id.to_s, notice: message
  end

  private
  def set_supplier
    @supplier = Supplier.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def supplier_params
    base = [:email, :tin, :street_and_number, :postal_code, :state, :country,
            :entreprise_name, :telephone_number1, :telephone_number2,
            :unit_type, :currency]
    if current_broker
      base.push(:identifier, :approved, :password, :password_confirmation)
    else
      if !params[:supplier][:current_password].blank? &&
       @supplier.valid_password?(params[:supplier][:current_password])
        base.push(:password, :password_confirmation)
      end
    end
    params.require(:supplier).permit(base)
  end

  def put_currencies_unit_types
    currencies = CURRENCIES.map do |currency|
      [I18n.t('currencies.' + currency + '.currency') +
       ' (' + I18n.t('currencies.' + currency + '.symbol') + ')',
       currency]
    end
    unit_types = UNIT_TYPES.map do |unit_type|
      [I18n.t('unit_types.' + unit_type + '.unit_type') +
       ' (' + I18n.t('unit_types.' + unit_type + '.symbol') + ')',
       unit_type]
    end
    return [currencies, unit_types]
  end
end

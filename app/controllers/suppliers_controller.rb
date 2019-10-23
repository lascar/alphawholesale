class SuppliersController < ApplicationController
  include Utilities
  before_action :authenticate_user!
  before_action :set_supplier,
   only: [:show, :edit, :update, :destroy]

  # GET /suppliers
  def index
    authorize :supplier, :index?
    @suppliers = Supplier.with_approved(true)
  end

  # GET /suppliers/1
  def show
    authorize @supplier
    @offers = @supplier.offers.includes(:product)
    @attached_products = make_attached_products(@supplier.attached_products)
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
      redirect_to supplier_new_path
    end
  end

  # PATCH/PUT /suppliers/1
  def update
    authorize @supplier
    if @supplier.update(supplier_params)
      if @supplier.previous_changes["approved"] == [false, true]
        SendUserApprovalJob.perform_later(@supplier)
      end
      redirect_to( @supplier,
       notice: I18n.t('controllers.suppliers.successfully_updated')) and return
    else
      flash[:alert] = helper_activerecord_error_message('supplier',
                                                  @supplier.errors.messages)
      redirect_to supplier_edit_path
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

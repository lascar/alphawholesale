class PackagingsController < ApplicationController
  include PackagingsHelper
  before_action :authenticate_user!
  before_action :verify_permission
  before_action :set_packaging, only: [:show, :edit, :update, :destroy]

  PACKAGING_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /packagings
  def index
    @packagings = Packaging.with_approved(true)
  end

  # GET /packagings/1
  def show
  end

  # GET /packagings/new
  def new
    @packaging = Packaging.new
    @products = Product.all.pluck(:name, :id)
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
    end
  end

  # GET /packagings/1/edit
  def edit
    @products = Product.all.pluck(:name, :id)
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
    end
  end

  # POST /packagings
  def create
    @packaging = Packaging.new(packaging_params)
    if supplier_signed_in?
      @packaging.supplier_id =  current_supplier.id
    end
    if @packaging.save
       flash[:notice] = I18n.t('controllers.packagings.successfully_created')
       redirect_to packaging_show_path
    else
      flash[:alert] = helper_activerecord_error_message('packaging',
                                                  @packaging.errors.messages)
      redirect_to packaging_new_path
    end
  end

  # PATCH/PUT /packagings/1
  def update
    if @packaging.update(packaging_params)
      redirect_to @packaging, notice:
       I18n.t('controllers.packagings.successfully_updated')
    else
      message = helper_activerecord_error_message('packaging',
                                                  @packaging.errors.messages)
      path = supplier_signed_in? ?
       edit_supplier_packaging_path(current_supplier) :
        edit_packaging_path
      redirect_to path, alert: message
    end
  end

  # DELETE /packagings/1
  def destroy
    @packaging.destroy
    redirect_to '/packagings',
     notice: I18n.t('controllers.packagings.successfully_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_packaging
      @packaging = Packaging.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def packaging_params
      params.require(:packaging).permit(:id, :name, :approved, :product_id)
    end
end

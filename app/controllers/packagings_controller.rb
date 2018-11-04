class PackagingsController < ApplicationController
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
       message = I18n.t('controllers.packagings.successfully_created')
       if supplier_signed_in?
         redirect_to supplier_packaging_path(
                                              @packaging.id.to_s,
                                              supplier_id: current_supplier.id,
                                              ), notice: message
       else
         redirect_to @packaging, notice: message
       end
    else
      message = ''
      @packaging.errors.messages.each do |k,v|
        message += I18n.t('activerecord.attributes.packaging.' + k.to_s) +
         ' : ' + v.inject(''){|s, m| s += m}
      end
      path = supplier_signed_in? ?
       new_supplier_packaging_path(current_supplier) :
        packagings_new_path
      redirect_to path, alert: message
    end
  end

  # PATCH/PUT /packagings/1
  def update
    if @packaging.update(packaging_params)
      redirect_to @packaging, notice:
       I18n.t('controllers.packagings.successfully_updated')
    else
      render :edit
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

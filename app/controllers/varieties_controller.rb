class VarietiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_variety, only: [:show, :edit, :update, :destroy]

  VARIETY_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /varieties
  def index
    @varieties = Variety.with_approved(true)
  end

  # GET /varieties/1
  def show
  end

  # GET /varieties/new
  def new
    @variety = Variety.new
    @products = Product.all.pluck(:name, :id)
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
    end
  end

  # GET /varieties/1/edit
  def edit
    @products = Product.all.pluck(:name, :id)
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
    end
  end

  # POST /varieties
  def create
    @variety = Variety.new(variety_params)
    @variety.supplier_id = supplier_signed_in? ? current_supplier.id :
      params[:supplier_id]
    if @variety.save
       redirect_to helper_show_variety_path, notice:
         I18n.t('controllers.varieties.successfully_created')
    else
      redirect_to helper_new_variety_path, alert:
        helper_activerecord_error_message('variety', @variety.errors.messages)
    end
  end

  # PATCH/PUT /varieties/1
  def update
    if @variety.update(variety_params)
      redirect_to @variety, notice:
       I18n.t('controllers.varieties.successfully_updated')
    else
      message = helper_activerecord_error_message('variety',
                                                  @variety.errors.messages)
      redirect_to helper_edit_variety_path, alert: message
    end
  end

  # DELETE /varieties/1
  def destroy
    @variety.destroy
    redirect_to '/varieties',
     notice: I18n.t('controllers.varieties.successfully_destroyed')
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_variety
    @variety = Variety.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def variety_params
    base = [:id, :name, :product_id]
    base.push(:approved) if broker_signed_in?
    params.require(:variety).permit(base)
  end
end

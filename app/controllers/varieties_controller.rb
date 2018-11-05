class VarietiesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_permission
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
    if supplier_signed_in?
      @variety.supplier_id =  current_supplier.id
    end
    I18n.locale = :fr
    if @variety.save
       message = I18n.t('controllers.varieties.successfully_created')
       if supplier_signed_in?
         redirect_to supplier_variety_path(
                                              @variety.id.to_s,
                                              supplier_id: current_supplier.id,
                                              ), notice: message
       else
         redirect_to @variety, notice: message
       end
    else
      message = helper_activerecord_error_message('variety',
                                                  @variety.errors.messages)
      redirect_to helper_new_variety_path, alert: message
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
      render :edit
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
      params.require(:variety).permit(:id, :name,
                                        :approved, :product_id)
    end
end

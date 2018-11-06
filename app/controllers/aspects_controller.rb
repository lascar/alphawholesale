class AspectsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_permission
  before_action :set_aspect, only: [:show, :edit, :update, :destroy]

  ASPECT_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /aspects
  def index
    @aspects = Aspect.with_approved(true)
  end

  # GET /aspects/1
  def show
  end

  # GET /aspects/new
  def new
    @aspect = Aspect.new
    @products = Product.all.pluck(:name, :id)
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
    end
  end

  # GET /aspects/1/edit
  def edit
    @products = Product.all.pluck(:name, :id)
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
    end
  end

  # POST /aspects
  def create
    @aspect = Aspect.new(aspect_params)
    if supplier_signed_in?
      @aspect.supplier_id =  current_supplier.id
    end
    if @aspect.save
       message = I18n.t('controllers.aspects.successfully_created')
       if supplier_signed_in?
         redirect_to supplier_aspect_path(
                                              @aspect.id.to_s,
                                              supplier_id: current_supplier.id,
                                              ), notice: message
       else
         redirect_to @aspect, notice: message
       end
    else
      message = helper_activerecord_error_message('aspect',
                                                  @aspect.errors.messages)
      path = supplier_signed_in? ?
       new_supplier_aspect_path(current_supplier) :
        new_aspect_path
      redirect_to path, alert: message
    end
  end

  # PATCH/PUT /aspects/1
  def update
    if @aspect.update(aspect_params)
      redirect_to @aspect, notice:
       I18n.t('controllers.aspects.successfully_updated')
    else
      message = helper_activerecord_error_message('aspect',
                                                  @aspect.errors.messages)
      path = supplier_signed_in? ?
       edit_supplier_aspect_path(current_supplier) :
        edit_aspect_path
      redirect_to path, alert: message
    end
  end

  # DELETE /aspects/1
  def destroy
    @aspect.destroy
    redirect_to '/aspects',
     notice: I18n.t('controllers.aspects.successfully_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aspect
      @aspect = Aspect.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def aspect_params
      params.require(:aspect).permit(:id, :name, :approved, :product_id)
    end
end

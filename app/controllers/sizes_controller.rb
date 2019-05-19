class SizesController < ApplicationController
  include SizesHelper
  before_action :authenticate_user!
  before_action :set_size, only: [:show, :edit, :update, :destroy]

  SIZE_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /sizes
  def index
    @sizes = Size.with_approved(true)
  end

  # GET /sizes/1
  def show
  end

  # GET /sizes/new
  def new
    @size = Size.new
    @products = Product.all.pluck(:name, :id)
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
    end
  end

  # GET /sizes/1/edit
  def edit
    @products = Product.all.pluck(:name, :id)
    if broker_signed_in?
      @suppliers = Supplier.all.pluck(:identifier, :id)
    end
  end

  # POST /sizes
  def create
    @size = Size.new(size_params)
    if supplier_signed_in?
      @size.supplier_id =  current_supplier.id
    end
    if @size.save
       message = I18n.t('controllers.sizes.successfully_created')
       redirect_to size_show_path(@size), notice: message
    else
      message = helper_activerecord_error_message('size',
                                                  @size.errors.messages)
      redirect_to size_new_path, alert: message
    end
  end

  # PATCH/PUT /sizes/1
  def update
    if @size.update(size_params)
      redirect_to @size, notice:
       I18n.t('controllers.sizes.successfully_updated')
    else
      message = helper_activerecord_error_message('size',
                                                  @size.errors.messages)
      path = supplier_signed_in? ?
       edit_supplier_size_path(current_supplier) :
        edit_size_path
      redirect_to path, alert: message
    end
  end

  # DELETE /sizes/1
  def destroy
    @size.destroy
    redirect_to '/sizes',
     notice: I18n.t('controllers.sizes.successfully_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_size
      @size = Size.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def size_params
      params.require(:size).permit(:id, :name,
                                        :approved, :product_id)
    end
end

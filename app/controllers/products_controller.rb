class ProductsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  PRODUCT_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/1
  def show
  end

  # GET /products/get_names
  def get_names
    authorize :product, :get_names?
    @names = Product.all.map{|p| p.name}
  end

  # GET /products/new
  def new
    if params[:product]
      product_name = params[:product][:name].match(PRODUCT_REGEXP) ?
       params[:product][:name] : nil
      product_name_new = params[:product][:name_new].match(PRODUCT_REGEXP) ?
       params[:product][:name_new] : nil
    end
    @product = Product.new(name: product_name || product_name_new)
    authorize @product
    products = product_name ? Product.where(name: product_name) : Product.all
  end

  # GET /products/1/edit
  def edit
    authorize @product
  end

  # POST /products
  def create
    name = product_params[:name]
    @product = Product.new(name: name)
    authorize @product
    if @product.save
       message = I18n.t('controllers.products.successfully_created')
       redirect_to @product, notice: message
    else
      message = helper_activerecord_error_message('product',
                                                  @product.errors.messages)
      path = products_get_names_path
      redirect_to path, alert: message
    end
  end

  # PATCH/PUT /products/1
  def update
    authorize @product
    if @product.update(product_params)
      redirect_to @product, notice:
       I18n.t('controllers.products.successfully_updated')
    else
      message = helper_activerecord_error_message('product',
                                                  @product.errors.messages)
      path = edit_product_path
      redirect_to path, alert: message
    end
  end

  # DELETE /products/1
  def destroy
    authorize @product
    @product.destroy
    redirect_to products_url,
     notice: I18n.t('controllers.products.successfully_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params.require(:product).permit(:name)
    end
end

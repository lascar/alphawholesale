class ProductsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  PRODUCT_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /products
  def index
    if supplier_signed_in?
      @products = Product.where(supplier_id: current_supplier.id) +
        Product.with_approved(true).
        select{|p| p.supplier_id != current_supplier.id}
    else
      @products = Product.with_approved(true)
    end
  end

  # GET /products/1
  def show
  end

  # GET /products/get_names
  def get_names
    @supplier = supplier_signed_in? ? current_supplier : nil
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
    @supplier = supplier_signed_in? ? current_supplier : nil
    @product = Product.new(name: product_name || product_name_new)
    products = product_name ? Product.where(name: product_name) : Product.all
    @varieties = product_name ?
     Variety.select{|v| v.product.name == product_name } :
     Variety.all
  end

  # GET /products/1/edit
  def edit
    @varieties = Variety.select{|v| v.product_id == @product.id}
  end

  # POST /products
  def create
    variety_new = params[:product] && params[:product][:variety_new] &&
     params[:product][:variety_new].match(PRODUCT_REGEXP) ?
      params[:product][:variety_new] : nil
    aspect_new = params[:product] && params[:product][:aspect_new] &&
     params[:product][:aspect_new].match(PRODUCT_REGEXP) ?
      params[:product][:aspect_new] : nil
    name = product_params[:name]
    variety = !product_params[:variety].blank? ? product_params[:variety] :
     variety_new
    aspect = !product_params[:aspect].blank? ? product_params[:aspect] :
     aspect_new
    supplier_id = supplier_signed_in? ? current_supplier.id :
                                        product_params[:supplier_id]
    @product = Product.new(name: name, variety: variety,
                           supplier_id: supplier_id)

    if @product.save
       message = I18n.t('controllers.products.successfully_created')
       if supplier_signed_in?
         redirect_to supplier_product_path(current_supplier, id: @product.id), notice: message
       else
         redirect_to @product, notice: message
       end
    else
      message = helper_activerecord_error_message('product',
                                                  @product.errors.messages)
      path = supplier_signed_in? ?
       supplier_products_get_names_path(current_supplier) :
       products_get_names_path
      redirect_to path, alert: message
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice:
       I18n.t('controllers.products.successfully_updated')
    else
      message = helper_activerecord_error_message('product',
                                                  @product.errors.messages)
      path = supplier_signed_in? ?
       edit_supplier_product_path(current_supplier) :
       edit_product_path
      redirect_to path, alert: message
    end
  end

  # DELETE /products/1
  def destroy
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
      params.require(:product).permit(:name, :variety, :aspect, :supplier_id,
                                      {:packagings => [:packaging]})
    end
end

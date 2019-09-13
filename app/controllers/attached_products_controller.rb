class AttachedProductsController < ApplicationController
  before_action :set_attached_product, only: [:show, :edit, :update, :destroy]
  before_action :set_object, only: [:index, :new, :create]

  # GET /attached_products
  def index
    if @object
      @attached_products = @object.attached_products
    else
      @attached_products = AttachedProduct.all
    end
  end

  # GET /attached_products/1
  def show
  end

  # GET /attached_products/new
  def new
    @attached_product = @object ? @object.attached_products.new : AttachedProduct.new
  end

  # GET /attached_products/1/edit
  def edit
  end

  # POST /attached_products
  def create
    @attached_product = @object ?
      @object.attached_products.new(attach_product_params) :
      AttachedProduct.new(attached_product_params)

    if @attached_product.save
      redirect_to attached_products_path, notice: 'Attach product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /attached_products/1
  def update
    if @attached_product.update(attached_product_params)
      redirect_to attached_products_path, notice: 'Attach product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /attached_products/1
  def destroy
    @attached_product.destroy
    redirect_to attached_products_path, notice: 'Attach product was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attached_product
      @attached_product = AttachedProduct.find(params[:id])
    end

    def set_object
      @object = current_customer || current_supplier
    end

    # Only allow a trusted parameter "white list" through.
    def attached_product_params
      base = [:product_id]
      if current_broker
        base.push(:attachable_type, :attachable_id)
      end
      params.require(:attached_product).permit(base)
    end
end

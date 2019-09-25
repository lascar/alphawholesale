class AttachedProductsController < ApplicationController
  before_action :set_object

  # GET /attached_products
  def index
    object_attached_products = @object.attached_products.includes(:product).
      includes(:variety).includes(:aspect).includes(:packaging)
    @attached_products = make_attached_hashs(object_attached_products)
  end

  # GET /attached_products/1/edit
  def edit
    attachable_products = AttachedProduct.includes(:product).includes(:variety).
      includes(:aspect).where(attachable_type: 'Broker')
    object_attached_products = @object.attached_products.includes(:product).
      includes(:variety).includes(:aspect).includes(:packaging)
		@attached_products = make_attached_hashs(object_attached_products, attachable_products)
	end

	# PATCH/PUT /attached_products/1
	def update
		@object.attached_products.destroy_all
		attached_products_params.each do |attachable_id|
			attachable = AttachedProduct.find attachable_id
			@object.attached_products.create(product_id: attachable.product_id,
																			 variety_id: attachable.variety_id,
																			 aspect_id: attachable.aspect_id,
																			 packaging_id: attachable.packaging_id)
		end
    redirect_to attached_products_path, notice: I18n.t('controllers.attached_products.update.succefully')
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_object
		@object = current_customer || current_supplier
	end

	# Only allow a trusted parameter "white list" through.
	def attached_products_params
		params.require(:attached_products)
	end

	def make_attached_hashs(object_attached_products, attached_products=nil)
    object_attached_products_hashs = object_attached_products.map do |object_attached_product|
      make_attached_hash(object_attached_product)
    end
    attached_products_hashs = attached_products&.map do |attached_product|
      attached_hash = make_attached_hash(attached_product)
      is_attached = object_attached_products_hashs.map{|hash| hash.except(:id)}.include? (attached_hash.except(:id))
      attached_hash.merge({is_attached: is_attached})
    end
    attached_products ? attached_products_hashs : object_attached_products_hashs
  end

  def make_attached_hash(attached_product)
    {id: attached_product.id,
     product_name: attached_product.product.name,
     variety_name: attached_product.variety&.name,
     aspect_name: attached_product.aspect&.name,
     packaging_name: attached_product.packaging&.name}
  end
end

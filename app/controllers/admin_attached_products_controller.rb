PARAMS_SEARCH = {'broker': 'Broker',
                 'supplier': 'Supplier',
                 'customer': 'Customer'}

class AdminAttachedProductsController < ApplicationController
  # GET /admin_attached_products
  def index
    @type =  PARAMS_SEARCH.fetch(params_search[:type]&.to_sym, 'Broker')
    @attached_products = make_attached_products
  end

  # GET /admin_attached_products/:id
  def show
  end

  # GET /admin_attached_products/new
  def new
  end

  # POST /admin_attached_products
  def create
  end

  def update
  end

  # GET /admin_attached_products/:id/edit
  def edit
  end

  # DELETE /admin_attached_products/:id
  def destroy
  end

  private
  def params_search
    base = [:type, :id]
    params.fetch(:search, {}).permit(base)
  end  

  def make_attached_products
    attached_products = AttachedProduct.where(attachable_type: @type).
     inject({}) do |hash, attached_product|
      type = attached_product.attachable_type
      id = attached_product.attachable_id
      identifier = attached_product.attachable.identifier
      hash[type + '_' + id.to_s + '_' + identifier] ||= []
      hash[type + '_' + id.to_s + '_' + identifier] << {id: attached_product.id,
                                  product_name: attached_product.product.name,
                                  variety_name: attached_product.variety&.name,
                                  aspect_name: attached_product.aspect&.name,
                                  packaging_name: attached_product.packaging&.name,
      }
      hash
    end
  end
end

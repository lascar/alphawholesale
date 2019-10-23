class AdminAttachedProductsController < ApplicationController
  include Utilities
  # GET /admin_attached_products
  def index
    attached_products = AttachedProduct.where(attachable_type: 'Broker')
    @attached_products = make_attached_products_hash(attached_products)
  end

  # GET /admin_attached_products/new
  def new
    @attachable_products = Product.all.inject([]) do |array, product|
      product_varieties = product.varieties.inject([]) do |array_varieties, variety|
        array_varieties << {variety_id: variety.id, variety_name: variety.name}
      end
      product_aspects = product.aspects.inject([]) do |array_aspects, aspect|
        array_aspects << {aspect_id: aspect.id, aspect_name: aspect.name}
      end
      product_packagings = product.packagings.inject([]) do |array_packagings, packaging|
        array_packagings << {packaging_id: packaging.id, packaging_name: packaging.name}
      end
      array << {product_id: product.id, product_name: product.name,
                product_varieties: product_varieties, product_aspects: product_aspects,
                product_packagings: product_packagings}
    end
  end

  # POST /admin_attached_products/create
  def create 
    attached_products = AttachedProduct.where(attachable_type: 'Broker').
     inject(Set[]) do |array, attached_product|
      product = Product.find_by_id attached_product.product_id
      product_hash = product ? {product_id: product.id, product_name: product.name} :
        {product_id: 0}
      variety = Variety.find_by_id attached_product.variety_id
      variety_hash = variety ? {variety_id: variety.id, variety_name: variety.name} :
        {variety_id: 0}
      aspect = Aspect.find_by_id attached_product.aspect_id
      aspect_hash = aspect ? {aspect_id: aspect.id, aspect_name: aspect.name} :
        {aspect_id: 0}
      packaging = Packaging.find_by_id attached_product.packaging_id
      packaging_hash = packaging ? {packaging_id: packaging.id, packaging_name: packaging.name} :
        {packaging_id: 0}
      array << product_hash.merge(variety_hash, aspect_hash, packaging_hash)

    end
    attached_checked_products = attached_products.dup
    products_hashes = params_create[:product]&.map do |product_id|
      product = Product.find_by_id product_id
      {product_id: product&.id, product_name: product&.name, variety_id: 0,
       aspect_id: 0, packaging_id: 0}
    end || []
    products_hashes.inject(attached_products) do |array, attached_product|
      array << attached_product
    end
    params_create[:products]&.to_h.inject(attached_products) do |attached_products, product|
      matches = product.first.match(/(?<id>\d+)_(?<name>[A-Za-z0-9_\-]+)/)
      hash_product = {product_id: matches[:id], product_name:matches[:name]}
      varieties_to_map = product.last[:varieties]&.map do |variety|
        matches = variety.match(/(?<id>\d+)_(?<name>[A-Za-z0-9_\-]+)/)
        [matches[:id], matches[:name]]
      end
      varieties = varieties_to_map || []
      aspects_to_map = product.last[:aspects]&.map do |aspect|
        matches = aspect.match(/(?<id>\d+)_(?<name>[A-Za-z0-9_\-]+)/)
        [matches[:id], matches[:name]]
      end
      aspects = aspects_to_map || []
      packagings_to_map = product.last[:packagings]&.map do |packaging|
        matches = packaging.match(/(?<id>\d+)_(?<name>[A-Za-z0-9_\-]+)/)
        [matches[:id], matches[:name]] || []
      end
      packagings = packagings_to_map || []
      varieties.each do |variety_id, variety_name|
        hash_variety = {variety_id: variety_id, variety_name: variety_name}
        attached_products << hash_product.merge(hash_variety)
        aspects.each do |aspect_id, aspect_name|
          hash_aspect = {aspect_id: aspect_id, aspect_name: aspect_name}
          attached_products << hash_product.merge(hash_variety, hash_aspect)
          packagings.each do |packaging_id, packaging_name|
            attached_products << hash_product.merge(hash_variety, hash_aspect,
                                                    {packaging_id: packaging_id,
                                                     packaging_name: packaging_name})
          end
        end
      end
      aspects.each do |aspect_id, aspect_name|
        hash_aspect = {aspect_id: aspect_id, aspect_name: aspect_name}
        attached_products << hash_product.merge(hash_aspect)
        packagings.each do |packaging_id, packaging_name|
          attached_products << hash_product.merge(hash_aspect, {packaging_id: packaging_id,
                                                                packaging_name: packaging_name})
        end
      end
      packagings.each do |packaging_id, packaging_name|
        attached_products << hash_product.merge({packaging_id: packaging_id,
                                                 packaging_name: packaging_name})
      end
      attached_products
    end
    @attached_products = attached_products.inject([]) do |array, attached_product|
      # attached_product : [[1, "product1"], [1, "variety1_product1"], [1, "aspect1_product1"], [1, "packaging1_product1"]]
      checked = attached_checked_products.include? attached_product
      array << attached_product.merge(checked: checked)
    end
    render :edit
  end

  # PATCH/PUT /admin_attached_products/1
  def update
    AttachedProduct.where(attachable_type: 'Broker').destroy_all
    array_attached_products = params_update[:attached_products].each do |attached_product|
      matches = attached_product.match(/(?<product_id>\d+)_(?<variety_id>\d*)_(?<aspect_id>\d*)_(?<packaging_id>\d*)/)
      variety_id = matches[:variety_id]
      aspect_id = matches[:aspect_id]
      packaging_id = matches[:packaging_id]
      AttachedProduct.find_or_create_by(attachable_type: 'Broker',
                                        attachable_id: current_broker.id,
                                        product_id: matches[:product_id],
                                        variety_id: variety_id == "0" ? nil : variety_id,
                                        aspect_id: aspect_id == "0" ? nil : aspect_id,
                                        packaging_id: packaging_id == "0" ? nil : packaging_id)
    end
    redirect_to admin_attached_products_path,
      notice: I18n.t('controllers.admin_attached_products.update.succefully')
  end

  private
  def params_new
    base = [:products => [], :varieties => [], :aspects => [], :packagings => []]
    params.fetch(:new, {}).permit(base)
  end

  def params_create
    base = [:product => [], :products => {}]
    params.fetch(:create, {}).permit(base)
  end

  def params_update
    base = [:attached_products => []]
    params.fetch(:update, {}).permit(base)
  end
end

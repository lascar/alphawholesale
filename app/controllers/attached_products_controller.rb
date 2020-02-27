class AttachedProductsController < ApplicationController
  include Utilities
  # GET /attached_products
  def index
    @attached_products = @user.attached_products
    @products = broker_signed_in? ? Product.all.pluck(:name, :name) :
      current_user.user_product.products
  end

  # GET /attached_products/new
  def new
    @products = broker_signed_in? ? Product.all.pluck(:name, :name) :
      current_user.user_product.products
    product = Product.find_by(name: params_new[:product])
    @product_name = product.name
    @varieties = product.assortments['varieties']
    @aspects = product.assortments['aspects']
    @packagings = product.assortments['packagings']
    @sizes = product.assortments['sizes']
    @calibers = product.assortments['calibers']
  end

  # POST /attached_products/create
  def create 
    definition = params_create.to_h.symbolize_keys
    definition.delete(:product)
    attached_product = AttachedProduct.find_or_create_by(product: params_create[:product],
                                           definition: definition,
                                           attachable: @user)
    message = attached_product.save ?
      I18n.t('controllers.attached_products.create.succefully') :
      helper_activerecord_error_message('attached_product',
                                        attached_product.errors)
    redirect_to path_for(user: @user, path: 'attached_products'), notice: message
  end

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
    redirect_to path_for(user: @user, path: 'attached_products'),
      notice: I18n.t('controllers.attached_products.update.succefully')
  end

  private
  def params_new
    base = [:product, :user_id, :user_type]
    params.fetch(:new_attached_product, {}).permit(base)
  end

  def params_create
    base = [:product, :variety, :aspect, :packaging, :size, :caliber]
    params.fetch(:create_attached_product, {}).permit(base)
  end

  def params_update
    base = [:attached_products => []]
    params.fetch(:update, {}).permit(base)
  end
end

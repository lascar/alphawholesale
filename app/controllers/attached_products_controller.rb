class AttachedProductsController < ApplicationController
  include Utilities
  # GET /attached_products
  def index
    @user_attached_products = @user.user_attached_products
    @attached_products = @user.attached_products
    @products = @user.products
  end

  # GET /attached_products/new
  def new
    @products = @user.products
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
    definition = verif_def_attach_prd (params_ate.to_h.symbolize_keys)
    attached_product = AttachedProduct.find_or_create_by(definition)
    if attached_product.save
      user_attached_product = UserAttachedProduct.find_or_create_by(user: @user,
                                       attached_product_id: attached_product.id)
      user_attached_product.mailing = params_ate[:mailing] || false
      if user_attached_product.save
        flash[:notice] = I18n.t('controllers.attached_products.create.succefully')
      else
        flash[:alert] = helper_activerecord_error_message('user_attached_product',
                                                          user_attached_product.errors)
      end
    else
      flash[:alert] = helper_activerecord_error_message('attached_product',
                                                        attached_product.errors)
    end
    redirect_to path_for(user: @user, path: 'attached_products')
  end

  def destroy
    attached_product = AttachedProduct.find (params[:id])
    if user_type(@user) == 'supplier'
      attached_product.suppliers.delete(@user)
    else
      attached_product.customers.delete(@user)
    end
    flash[:notice] = I18n.t('controllers.attached_products.destroy.succefully')
    redirect_to path_for(user: @user, path: 'attached_products')
  end

  private
  def params_new
    base = [:product, :user_id, :user_type]
    params.fetch(:new_attached_product, {}).permit(base)
  end

  def params_ate
    base = [:product, :variety, :aspect, :packaging, :size, :caliber, :mailing]
    params.fetch(:attached_product, {}).permit(base)
  end
end

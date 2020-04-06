class ConcreteProductsController < ApplicationController
  include Utilities
  # GET /concrete_products
  def index
    @user_concrete_products = @user.user_concrete_products
    @concrete_products = @user.concrete_products
    @products = @user.products.pluck(:name)
  end

  # GET /concrete_products/new
  def new
    @products = @user.products.pluck(:name)
    product = Product.find_by(name: params_new[:product])
    @product_name = product.name
    @varieties = product.assortments['varieties']
    @aspects = product.assortments['aspects']
    @packagings = product.assortments['packagings']
    @sizes = product.assortments['sizes']
    @calibers = product.assortments['calibers']
  end

  # POST /concrete_products/create
  def create
    definition = verif_def_attach_prd (params_ate.to_h.symbolize_keys)
    concrete_product = ConcreteProduct.find_or_create_by(definition)
    if concrete_product.save
      user_concrete_product = UserConcreteProduct.find_or_create_by(user: @user,
                                       concrete_product_id: concrete_product.id)
      user_concrete_product.mailing = params_ate[:mailing] || false
      if user_concrete_product.save
        flash[:notice] = I18n.t('controllers.concrete_products.create.succefully')
      else
        flash[:alert] = helper_activerecord_error_message('user_concrete_product',
                                                          user_concrete_product.errors)
      end
    else
      flash[:alert] = helper_activerecord_error_message('concrete_product',
                                                        concrete_product.errors)
    end
    redirect_to path_for(user: @user, path: 'concrete_products')
  end

  def destroy
    concrete_product = ConcreteProduct.find (params[:id])
    if user_type(@user) == 'supplier'
      concrete_product.suppliers.delete(@user)
    else
      concrete_product.customers.delete(@user)
    end
    flash[:notice] = I18n.t('controllers.concrete_products.destroy.succefully')
    redirect_to path_for(user: @user, path: 'concrete_products')
  end

  private
  def params_new
    base = [:product, :user_id, :user_type]
    params.fetch(:new_concrete_product, {}).permit(base)
  end

  def params_ate
    base = [:product, :variety, :aspect, :packaging, :size, :caliber, :mailing]
    params.fetch(:concrete_product, {}).permit(base)
  end
end

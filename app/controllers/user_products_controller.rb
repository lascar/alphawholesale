class UserProductsController < ApplicationController

  PRODUCT_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /user_products
  def index
    @products = make_user_products_array
  end

  # PATCH/PUT /user_products/1
  def update
    current_user.user_products = make_user_products
    if current_user.save
      flash[:notice] = I18n.t('controllers.user_products.update.succefully')
    else
      flash[:alert] = helper_activerecord_error_message('user_product',
       current_user.errors.messages)
    end
    redirect_to path_for(user: current_user, path: 'user_products')
  end

  private
  def make_user_products
    user_products = []
    params_update["user_products"].each do |user_product|
      product = Product.find_by_id user_product["product_id"]
      user_products << UserProduct.new({user_type: current_user.class.name,
                                        user_id: current_user.id,
                                        product_id: product.id,
                                        mailing: !!user_product["mailing"]})
    end
    user_products
  end

  def params_update
    base = [:product_id, :mailing]
    params.permit(user_products: base)
  end

  def make_user_products_array
    Product.all.inject([]) do |array_user_products, product|
      user_product = UserProduct.find_by(user_type: @user.class.name,
                                          user_id: @user.id,
                                          product_id: product.id)
      array_user_products << {id: product.id, name: product.name,
                              user_product: !!user_product,
                              mailing: !!user_product&.mailing}
    end
  end
end

class UserProductsController < ApplicationController

  PRODUCT_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /user_products
  def index
    @products = Product.pluck(:name)
    @user_products = current_user.user_product.products
  end

  # PATCH/PUT /user_products/1
  def update
    products = []
    params_update[:user_products].each do |name|
      if name.match(PRODUCT_REGEXP)
        products << name
      end
    end
    current_user.user_product.products = products
    current_user.user_product.save
    path = path_for(user: current_user, path: 'user_products', object: nil)
    message = I18n.t('controllers.user_products.update.succefully')
    redirect_to path, notice: message
  end

  private
  def params_update
    params.permit(:user_products => [])
  end
end

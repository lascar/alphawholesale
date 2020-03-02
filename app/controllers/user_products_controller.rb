class UserProductsController < ApplicationController

  PRODUCT_REGEXP = /^[0-9a-zA-Z_\- ]+$/
  # GET /user_products
  def index
    @products = Product.pluck(:name)
    @user_products = current_user.products
  end

  # PATCH/PUT /user_products/1
  def update
    products = []
    params_update[:user_products].each do |name|
      if name.match(PRODUCT_REGEXP)
        products << name
      end
    end
    current_user.products = products
    if current_user.save
      flash[:notice] = I18n.t('controllers.user_products.update.succefully')
    else
      flash[:alert] = helper_activerecord_error_message('user_product',
       current_user.errors.messages)
    end
    redirect_to path_for(user: current_user, path: 'user_products')
  end

  private
  def params_update
    params.permit(:user_products => [])
  end
end

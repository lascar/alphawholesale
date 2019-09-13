class RevertCreateProductCustomer < ActiveRecord::Migration[6.0]
  require_relative '20181018082948_create_product_customer'
  def change
    revert CreateProductCustomer
  end
end

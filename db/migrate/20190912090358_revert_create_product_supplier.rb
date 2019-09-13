class RevertCreateProductSupplier < ActiveRecord::Migration[6.0]
  require_relative '20180919082948_create_product_supplier'
  def change
    revert CreateProductSupplier
  end
end

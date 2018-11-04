class CreateProductCustomer < ActiveRecord::Migration[5.2]
  def change
    create_table :product_customers do |t|
      t.belongs_to :customer, index: true
      t.belongs_to :product, index: true

      t.timestamps
    end
  end
end

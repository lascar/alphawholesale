class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.belongs_to :customer
      t.belongs_to :offer
      t.belongs_to :concrete_product
      t.text :customer_observation
      t.integer :quantity,         default: 1
      t.boolean :approved,         default: false

      t.timestamps
    end
  end
end

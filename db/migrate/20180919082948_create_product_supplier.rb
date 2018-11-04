class CreateProductSupplier < ActiveRecord::Migration[5.2]
  def change
    create_table :product_suppliers do |t|
      t.belongs_to :supplier, index: true
      t.belongs_to :product, index: true

      t.timestamps
    end
  end
end

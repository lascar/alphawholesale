class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.references :customer, null: false, foreign_key: true
      t.belongs_to :concrete_product
      t.integer :quantity
      t.text :customer_observation
      t.date :date_start
      t.date :date_end
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end

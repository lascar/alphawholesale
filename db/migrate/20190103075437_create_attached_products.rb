class CreateAttachedProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :attached_products do |t|
      t.string :product, null: false
      t.string :variety
      t.string :aspect
      t.string :packaging
      t.string :size
      t.string :caliber

      t.timestamps
    end
    add_index :attached_products, :product
  end
end

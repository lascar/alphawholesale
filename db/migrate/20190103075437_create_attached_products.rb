class CreateAttachedProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :attached_products do |t|
      t.string :product, null: false
      t.string :variety, default: 'not_specified'
      t.string :aspect, default: 'not_specified'
      t.string :packaging, default: 'not_specified'
      t.string :size, default: 'not_specified'
      t.string :caliber, default: 'not_specified'

      t.timestamps
    end
    add_index :attached_products, :product
  end
end

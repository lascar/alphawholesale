class UserProduct < ActiveRecord::Migration[6.0]
  def change
    create_table :user_products do |t|
      t.references :user, polymorphic: true, null: false
      t.jsonb :products, default: []

      t.timestamps
    end
    add_index :user_products, :products, using: :gin
  end
end

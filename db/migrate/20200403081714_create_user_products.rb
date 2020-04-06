class CreateUserProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :user_products do |t|
      t.references :user, polymorphic: true, null: false
      t.references :product, null: false, foreign_key: true
      t.jsonb :conditions, default: {}, null: false
      t.boolean :mailing, default: false

      t.timestamps
    end
  end
end

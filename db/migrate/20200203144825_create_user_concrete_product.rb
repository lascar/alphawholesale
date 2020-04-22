class CreateUserConcreteProduct < ActiveRecord::Migration[6.0]
  def change
    create_table :user_concrete_products do |t|
      t.references :user, polymorphic: true, index: true
      t.references :concrete_product

      t.timestamps
    end
  end
end

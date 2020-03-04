class UserAttachedProduct < ActiveRecord::Migration[6.0]
  def change
    create_table :user_attached_products do |t|
      t.references :user, polymorphic: true, index: true
      t.references :attached_product
      t.boolean    :mailing, default: false

      t.timestamps
    end
  end
end

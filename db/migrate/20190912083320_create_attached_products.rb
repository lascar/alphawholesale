class CreateAttachedProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :attached_products do |t|
      t.references :product, null: false, foreign_key: true
      t.references :variety, foreign_key: true
      t.references :aspect, foreign_key: true
      t.references :packaging, foreign_key: true
      t.references :attachable, polymorphic: true, null: false
      t.boolean    :mailing, default: false

      t.timestamps
    end
  end
end

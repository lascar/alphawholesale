class CreateAttachedProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :attached_products do |t|
      t.string :product
      t.jsonb :definition, default: {}, null: false
      t.references :attachable, polymorphic: true, null: false
      t.boolean    :mailing, default: false

      t.timestamps
    end
    add_index :attached_products, :definition, using: :gin
    # add_index :attached_products, :definition, name: 'attached_products_definition_idx', using: :gin
  end
end

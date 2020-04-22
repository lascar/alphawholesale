class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.references :supplier, null: false, foreign_key: true
      t.references :concrete_product, null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :unit_price_supplier, :precision => 8, :scale => 2, :null => false, default: 0
      t.decimal :unit_price_broker, :precision => 8, :scale => 2, :null => false, default: 0
      t.string :localisation_supplier
      t.string :localisation_broker
      t.string :incoterm
      t.text :supplier_observation
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end

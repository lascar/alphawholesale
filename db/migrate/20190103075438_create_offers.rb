class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.belongs_to :supplier
      t.belongs_to :concrete_product
      t.integer :quantity
      t.decimal :unit_price_supplier, :precision => 8, :scale => 2, :null => false, default: 0
      t.decimal :unit_price_broker, :precision => 8, :scale => 2, :null => false, default: 0
      t.string :localisation_supplier
      t.string :localisation_broker
      t.string :incoterm
      t.text :supplier_observation
      t.date :date_start
      t.date :date_end
      t.boolean :approved,         default: false

      t.timestamps
    end
  end
end

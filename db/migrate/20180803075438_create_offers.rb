class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.belongs_to :supplier
      t.belongs_to :product
      t.belongs_to :variety
      t.belongs_to :aspect
      t.belongs_to :size
      t.belongs_to :packaging
      t.boolean :approved,         default: false
      t.integer :quantity
      t.decimal :unit_price_supplier, :precision => 8, :scale => 2, :null => false, default: 0
      t.decimal :unit_price_broker, :precision => 8, :scale => 2, :null => false, default: 0
      t.string :currency
      t.string :unit_type
      t.string :localisation_supplier
      t.string :localisation_broker
      t.string :incoterm
      t.text :observation
      t.date :date_start
      t.date :date_end

      t.timestamps
    end
  end
end

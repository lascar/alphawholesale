class CreateTenderLines < ActiveRecord::Migration[5.2]
  def change
    create_table :tender_lines do |t|
      t.belongs_to :tender, index: true
      t.belongs_to :product, index: true
      t.belongs_to :variety
      t.belongs_to :aspect
      t.belongs_to :size
      t.belongs_to :packaging
      t.integer :unit
      t.integer :unit_price
      t.text :observation

      t.timestamps
    end
  end
end

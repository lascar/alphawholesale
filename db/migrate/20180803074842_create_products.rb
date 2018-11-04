class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.belongs_to :supplier
      t.string :reference
      t.string :name
      t.string :variety
      t.boolean :approved,         default: false

      t.timestamps
    end
  end
end

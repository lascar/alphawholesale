class CreateVarieties < ActiveRecord::Migration[5.2]
  def change
    create_table :varieties do |t|
      t.belongs_to :product
      t.belongs_to :supplier
      t.string :name
      t.boolean :approved,         default: false

      t.timestamps
    end
  end
end

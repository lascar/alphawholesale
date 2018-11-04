class CreateSizes < ActiveRecord::Migration[5.2]
  def change
    create_table :sizes do |t|
      t.belongs_to :supplier
      t.belongs_to :product
      t.string :name
      t.boolean :approved,         default: false

      t.timestamps
    end
  end
end

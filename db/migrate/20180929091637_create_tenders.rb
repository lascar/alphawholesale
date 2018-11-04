class CreateTenders < ActiveRecord::Migration[5.2]
  def change
    create_table :tenders do |t|
      t.belongs_to :customer, index: true
      t.boolean :approved,         default: false
      t.datetime :date_start
      t.datetime :date_end

      t.timestamps
    end
  end
end

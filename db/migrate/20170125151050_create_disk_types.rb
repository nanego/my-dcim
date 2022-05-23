class CreateDiskTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :disk_types do |t|
      t.integer :quantity
      t.string :unit
      t.string :technology

      t.timestamps null: false
    end
  end
end

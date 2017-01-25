class CreateMemoryTypes < ActiveRecord::Migration
  def change
    create_table :memory_types do |t|
      t.integer :quantity
      t.string :unit

      t.timestamps null: false
    end
  end
end

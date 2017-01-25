class CreateMemoryComponents < ActiveRecord::Migration
  def change
    create_table :memory_components do |t|
      t.integer :server_id
      t.integer :memory_type_id
      t.integer :quantity

      t.timestamps null: false
    end
  end
end

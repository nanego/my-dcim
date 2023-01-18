# frozen_string_literal: true

class CreateMemoryComponents < ActiveRecord::Migration[4.2]
  def change
    create_table :memory_components do |t|
      t.integer :server_id
      t.integer :memory_type_id
      t.integer :quantity

      t.timestamps null: false
    end
  end
end

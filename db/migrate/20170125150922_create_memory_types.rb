# frozen_string_literal: true

class CreateMemoryTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :memory_types do |t|
      t.integer :quantity
      t.string :unit

      t.timestamps null: false
    end
  end
end

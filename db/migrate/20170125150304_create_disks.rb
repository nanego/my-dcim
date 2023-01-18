# frozen_string_literal: true

class CreateDisks < ActiveRecord::Migration[4.2]
  def change
    create_table :disks do |t|
      t.integer :server_id
      t.integer :disk_type_id
      t.integer :quantity

      t.timestamps null: false
    end
  end
end

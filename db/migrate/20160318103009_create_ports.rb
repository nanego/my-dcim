# frozen_string_literal: true

class CreatePorts < ActiveRecord::Migration[4.2]
  def change
    create_table :ports do |t|
      t.integer :position
      t.integer :parent_id
      t.string :parent_type

      t.timestamps null: false
    end
  end
end

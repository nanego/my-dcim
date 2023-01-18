# frozen_string_literal: true

class CreateIslets < ActiveRecord::Migration[4.2]
  def change
    create_table :islets do |t|
      t.string :name
      t.integer :room_id

      t.timestamps null: false
    end
  end
end

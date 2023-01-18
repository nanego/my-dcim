# frozen_string_literal: true

class CreatePdus < ActiveRecord::Migration[4.2]
  def change
    create_table :pdus do |t|
      t.integer :frame_id
      t.string :name

      t.timestamps null: false
    end
  end
end

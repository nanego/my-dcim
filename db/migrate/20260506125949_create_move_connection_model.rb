# frozen_string_literal: true

class CreateMoveConnectionModel < ActiveRecord::Migration[8.1]
  def change
    create_table :move_connections do |t|
      t.string :cable_name
      t.string :cable_color
      t.string :vlans

      t.datetime :executed_at

      t.references :move, null: false, foreign_key: true
      t.references :port_from, null: false, foreign_key: { to_table: :ports }
      t.references :port_to, null: true, foreign_key: { to_table: :ports }

      t.timestamps
    end
  end
end

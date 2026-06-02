# frozen_string_literal: true

class DropMovedConnections < ActiveRecord::Migration[8.1]
  def change
    drop_table :moved_connections, id: :serial do |t|
      t.string :cablename
      t.string :color
      t.datetime :created_at, null: false
      t.datetime :executed_at
      t.integer :port_from_id
      t.integer :port_to_id
      t.datetime :updated_at, null: false
      t.string :vlans

      t.index :port_from_id, name: "index_moved_connections_on_port_from_id"
      t.index :port_to_id, name: "index_moved_connections_on_port_to_id"

      t.foreign_key :ports, column: :port_from_id
      t.foreign_key :ports, column: :port_to_id
    end
  end
end

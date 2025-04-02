# frozen_string_literal: true

class CreateConnections < ActiveRecord::Migration[4.2]
  def change
    create_table :connections do |t|
      t.integer :source_port_id
      t.integer :destination_port_id

      t.timestamps null: false
    end
  end
end

class CreateConnectionsFromPorts < ActiveRecord::Migration[5.0]
  def change
    create_table :connections do |t|
      t.integer :cable_id
      t.integer :port_id

      t.timestamps
    end
    add_index :connections, [:cable_id, :port_id], unique: true
  end
end

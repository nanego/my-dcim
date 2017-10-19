class CreateMovedConnections < ActiveRecord::Migration[5.0]
  def change
    create_table :moved_connections do |t|
      t.integer :port_from_id
      t.integer :port_to_id
      t.string :vlans
      t.string :cablename
      t.string :color

      t.timestamps
    end
  end
end

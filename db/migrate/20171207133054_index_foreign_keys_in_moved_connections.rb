class IndexForeignKeysInMovedConnections < ActiveRecord::Migration[4.2]
  def change
    add_index :moved_connections, :port_from_id
    add_index :moved_connections, :port_to_id
  end
end

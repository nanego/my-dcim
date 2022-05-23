class IndexForeignKeysInConnections < ActiveRecord::Migration[4.2]
  def change
    add_index :connections, :port_id
  end
end

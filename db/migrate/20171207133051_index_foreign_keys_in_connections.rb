class IndexForeignKeysInConnections < ActiveRecord::Migration
  def change
    add_index :connections, :port_id
  end
end

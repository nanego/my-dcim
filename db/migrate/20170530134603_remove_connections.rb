class RemoveConnections < ActiveRecord::Migration[5.0]
  def change
    drop_table :connections
  end
end

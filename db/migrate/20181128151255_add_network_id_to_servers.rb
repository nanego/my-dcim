class AddNetworkIdToServers < ActiveRecord::Migration[5.1]
  def change
    add_column :servers, :network_id, :integer
  end
end

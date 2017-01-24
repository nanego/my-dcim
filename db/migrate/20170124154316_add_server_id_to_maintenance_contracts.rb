class AddServerIdToMaintenanceContracts < ActiveRecord::Migration
  def change
    add_column :maintenance_contracts, :server_id, :integer
  end
end

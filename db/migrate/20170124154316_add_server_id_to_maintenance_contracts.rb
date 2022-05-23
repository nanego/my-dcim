class AddServerIdToMaintenanceContracts < ActiveRecord::Migration[4.2]
  def change
    add_column :maintenance_contracts, :server_id, :integer
  end
end

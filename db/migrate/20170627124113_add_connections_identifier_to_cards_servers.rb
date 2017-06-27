class AddConnectionsIdentifierToCardsServers < ActiveRecord::Migration[5.0]
  def change
    add_column :cards_servers, :connections_identifier, :string
  end
end

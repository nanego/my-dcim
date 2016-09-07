class RenameCardServeursToCardServers< ActiveRecord::Migration
  def change
    rename_table :cards_serveurs, :cards_servers
  end
end

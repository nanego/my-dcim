# frozen_string_literal: true

class RenameCardServeursToCardServers< ActiveRecord::Migration[4.2]
  def change
    rename_table :cards_serveurs, :cards_servers
  end
end

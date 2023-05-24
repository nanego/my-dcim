# frozen_string_literal: true

class RenameCardsServersToCards < ActiveRecord::Migration[5.0]
  def change
    rename_table :cards_servers, :cards
    rename_column :ports, :cards_server_id, :card_id
  end
end

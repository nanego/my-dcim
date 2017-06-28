class RenameCardsToCardTypes < ActiveRecord::Migration[5.0]
  def change
    rename_table :cards, :card_types
    rename_column :cards_servers, :card_id, :card_type_id
  end
end

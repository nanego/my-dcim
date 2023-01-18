# frozen_string_literal: true

class RenameLinkedCardsToTwins < ActiveRecord::Migration[5.1]
  def change
    rename_column :cards, :linked_card_id, :twin_card_id
  end
end

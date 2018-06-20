class AddLinkedCardToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :linked_card_id, :integer
  end
end

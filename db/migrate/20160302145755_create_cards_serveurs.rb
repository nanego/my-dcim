class CreateCardsServeurs < ActiveRecord::Migration
  def change
    create_table :cards_serveurs do |t|
      t.integer :card_id
      t.integer :serveur_id
      t.integer :composant_id
    end
  end
end

class AddComposantIdToSlots < ActiveRecord::Migration
  def change
    add_column :slots, :composant_id, :integer
    remove_column :slots, :serveur_id, :integer
  end
end

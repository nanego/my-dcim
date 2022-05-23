class AddServeurIdToSlots < ActiveRecord::Migration[4.2]
  def change
    add_column :slots, :serveur_id, :integer
  end
end

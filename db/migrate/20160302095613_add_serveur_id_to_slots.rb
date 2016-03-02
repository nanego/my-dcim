class AddServeurIdToSlots < ActiveRecord::Migration
  def change
    add_column :slots, :serveur_id, :integer
  end
end

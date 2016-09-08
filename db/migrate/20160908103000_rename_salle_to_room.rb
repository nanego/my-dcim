class RenameSalleToRoom< ActiveRecord::Migration
  def change
    rename_table :salles, :rooms
    rename_column :frames, :salle_id, :room_id
  end
end

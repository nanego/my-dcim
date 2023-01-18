# frozen_string_literal: true

class RenameSalleToRoom< ActiveRecord::Migration[4.2]
  def change
    rename_table :salles, :rooms
    rename_column :frames, :salle_id, :room_id
  end
end

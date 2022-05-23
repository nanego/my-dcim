class RenameBaieToFrame< ActiveRecord::Migration[4.2]
  def change
    rename_table :baies, :frames
    rename_column :servers, :baie_id, :frame_id
  end
end

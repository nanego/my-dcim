class RenameBaieToFrame< ActiveRecord::Migration
  def change
    rename_table :baies, :frames
    rename_column :servers, :baie_id, :frame_id
  end
end

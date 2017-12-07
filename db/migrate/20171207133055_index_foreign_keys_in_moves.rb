class IndexForeignKeysInMoves < ActiveRecord::Migration
  def change
    add_index :moves, :frame_id
    add_index :moves, :prev_frame_id
  end
end

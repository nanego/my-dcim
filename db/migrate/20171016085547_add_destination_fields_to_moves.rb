class AddDestinationFieldsToMoves < ActiveRecord::Migration[5.0]
  def change
    add_column :moves, :prev_frame_id, :integer
    add_column :moves, :frame_id, :integer
    add_column :moves, :position, :integer
  end
end

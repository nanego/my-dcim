class RemoveIlotColumnFromFrames < ActiveRecord::Migration
  def change
    remove_column :frames, :ilot, :integer
  end
end

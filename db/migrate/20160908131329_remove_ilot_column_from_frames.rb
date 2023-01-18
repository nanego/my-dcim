# frozen_string_literal: true

class RemoveIlotColumnFromFrames < ActiveRecord::Migration[4.2]
  def change
    remove_column :frames, :ilot, :integer
    remove_column :frames, :room_id, :integer
  end
end

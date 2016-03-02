class AddPositionToSlots < ActiveRecord::Migration
  def change
    rename_column :slots, :numero, :position
  end
end

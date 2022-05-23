class AddPositionToSlots < ActiveRecord::Migration[4.2]
  def change
    rename_column :slots, :numero, :position
  end
end

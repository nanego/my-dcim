class AddPositionToServeurs < ActiveRecord::Migration[4.2]
  def change
    add_column :serveurs, :position, :integer
  end
end

class AddPositionToServeurs < ActiveRecord::Migration
  def change
    add_column :serveurs, :position, :integer
  end
end

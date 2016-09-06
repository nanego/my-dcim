class AddPositionToSalles < ActiveRecord::Migration
  def change
    add_column :salles, :position, :integer
  end
end

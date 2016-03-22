class AddPositionToBaies < ActiveRecord::Migration
  def change
    add_column :baies, :position, :integer
  end
end

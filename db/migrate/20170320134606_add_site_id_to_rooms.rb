class AddSiteIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :site_id, :integer
  end
end

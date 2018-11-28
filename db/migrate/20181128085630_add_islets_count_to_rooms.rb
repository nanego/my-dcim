class AddIsletsCountToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :islets_count, :integer, :default => 0
  end
end

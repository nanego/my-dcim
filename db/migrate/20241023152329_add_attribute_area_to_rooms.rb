# frozen_string_literal: true

class AddAttributeAreaToRooms < ActiveRecord::Migration[7.2]
  def change
    add_column :rooms, :surface_area, :integer
  end
end

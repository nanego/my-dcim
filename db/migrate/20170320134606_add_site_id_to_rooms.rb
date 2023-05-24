# frozen_string_literal: true

class AddSiteIdToRooms < ActiveRecord::Migration[4.2]
  def change
    add_column :rooms, :site_id, :integer
  end
end

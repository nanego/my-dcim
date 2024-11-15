# frozen_string_literal: true

class AddAttributeAccessControlToRoomIsletBay < ActiveRecord::Migration[7.2]
  def change
    add_column :rooms, :access_control, :integer
    add_column :islets, :access_control, :integer
    add_column :bays, :access_control, :integer
  end
end

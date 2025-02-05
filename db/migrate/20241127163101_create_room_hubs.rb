# frozen_string_literal: true

class CreateRoomHubs < ActiveRecord::Migration[7.2]
  def change
    create_table :room_hubs do |t|
      t.references :server_a, null: false, foreign_key: { to_table: :servers }
      t.references :server_b, null: false, foreign_key: { to_table: :servers }
      t.string :network_types, array: true, default: []

      t.timestamps

      t.index %i[server_a_id server_b_id], unique: true
    end

    up_only do
      RoomHub.create!(server_a_id: 383, server_b_id: 384, network_types: ["gbe"])
      RoomHub.create!(server_a_id: 1043, server_b_id: 1044, network_types: ["10gbe"])
    end
  end
end

# frozen_string_literal: true

class CreateRoomHubs < ActiveRecord::Migration[7.2]
  def change
    create_table :room_hubs do |t|
      t.references :from_room, null: false, foreign_key: { to_table: :rooms }
      t.references :to_room, null: false, foreign_key: { to_table: :rooms }
      t.references :hub, null: false, foreign_key: { to_table: :servers }
      t.string :network_types, array: true, default: []

      t.timestamps
    end

    up_only do
      RoomHub.create!(from_room_id: 4, to_room_id: 3, hub_id: 383, network_types: ["gbe"])
      RoomHub.create!(from_room_id: 3, to_room_id: 4, hub_id: 384, network_types: ["gbe"])

      RoomHub.create!(from_room_id: 4, to_room_id: 3, hub_id: 1043, network_types: ["10gbe"])
      RoomHub.create!(from_room_id: 3, to_room_id: 4, hub_id: 1044, network_types: ["10gbe"])
    end
  end
end

# frozen_string_literal: true

class AddMissingNotNullableToExistingTables < ActiveRecord::Migration[7.0]
  def change
    change_column_null :moves, :moveable_type, false
    change_column_null :moves, :moveable_id, false
    change_column_null :moves, :frame_id, false
    change_column_null :moves, :prev_frame_id, false

    change_column_null :modeles, :category_id, false

    change_column_null :memory_components, :server_id, false
    change_column_null :memory_components, :memory_type_id, false

    change_column_null :maintenance_contracts, :maintainer_id, false
    change_column_null :maintenance_contracts, :contract_type_id, false
    change_column_null :maintenance_contracts, :server_id, false

    change_column_null :rooms, :site_id, false

    change_column_null :islets, :room_id, false

    change_column_null :frames, :bay_id, false

    change_column_null :enclosures, :modele_id, false

    change_column_null :documents, :server_id, false

    change_column_null :disks, :server_id, false
    change_column_null :disks, :disk_type_id, false

    change_column_null :connections, :cable_id, false

    change_column_null :cards, :card_type_id, false
    change_column_null :cards, :server_id, false

    change_column_null :bays, :bay_type_id, false
    change_column_null :bays, :islet_id, false

    change_column_null :composants, :type_composant_id, false

    change_column_null :servers, :frame_id, false

    change_column_null :card_types, :port_type_id, false
  end
end

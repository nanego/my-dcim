# frozen_string_literal: true

class AddMissingIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :bays, :bay_type_id
    add_index :bays, :islet_id
    add_index :cards, :port_type_id
    add_index :cards_servers, :card_id
    add_index :cards_servers, :composant_id
    add_index :cards_servers, :server_id
    add_index :composants, :modele_id
    add_index :composants, :type_composant_id
    add_index :disks, :disk_type_id
    add_index :disks, :server_id
    add_index :frames, :bay_id
    add_index :islets, :room_id
    add_index :maintenance_contracts, :contract_type_id
    add_index :maintenance_contracts, :maintainer_id
    add_index :maintenance_contracts, :server_id
    add_index :memory_components, :memory_type_id
    add_index :memory_components, :server_id
    add_index :modeles, :architecture_id
    add_index :modeles, :category_id
    add_index :modeles, :marque_id
    add_index :pdu_lines, :pdu_id
    add_index :pdu_outlet_groups, :pdu_line_id
    add_index :pdus, :frame_id
    add_index :ports, %i[parent_id parent_type]
    add_index :rooms, :site_id
    add_index :servers, :acte_id
    add_index :servers, :cluster_id
    add_index :servers, :domaine_id
    add_index :servers, :frame_id
    add_index :servers, :gestion_id
    add_index :servers, :modele_id
    add_index :servers, :server_state_id
    add_index :slots, :composant_id
    add_index :slots, :server_id
    add_index :users, %i[invited_by_id invited_by_type]
  end
end

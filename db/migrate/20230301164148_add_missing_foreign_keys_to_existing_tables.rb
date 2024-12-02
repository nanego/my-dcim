# frozen_string_literal: true

class AddMissingForeignKeysToExistingTables < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :moves, :frames
    add_foreign_key :moves, :frames, column: :prev_frame_id

    add_foreign_key :modeles, :manufacturers
    add_foreign_key :modeles, :architectures
    add_foreign_key :modeles, :categories

    add_foreign_key :memory_components, :memory_types

    add_foreign_key :maintenance_contracts, :maintainers
    add_foreign_key :maintenance_contracts, :contract_types
    add_foreign_key :maintenance_contracts, :servers

    add_foreign_key :rooms, :sites

    add_foreign_key :frames, :bays

    add_foreign_key :documents, :servers

    add_foreign_key :disks, :disk_types

    add_foreign_key :connections, :cables

    add_foreign_key :cards, :card_types

    add_foreign_key :bays, :bay_types
    add_foreign_key :bays, :islets

    add_foreign_key :composants, :type_composants

    add_foreign_key :servers, :gestions
    add_foreign_key :servers, :modeles
    add_foreign_key :servers, :clusters
    add_foreign_key :servers, :server_states
    add_foreign_key :servers, :stacks

    add_foreign_key :card_types, :port_types
  end
end

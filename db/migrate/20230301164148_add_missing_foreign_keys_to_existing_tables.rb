class AddMissingForeignKeysToExistingTables < ActiveRecord::Migration[5.2]
  def change
    # add_foreign_key :ports, :cards

    # add_foreign_key :moved_connections, :port_froms
    # add_foreign_key :moved_connections, :port_tos

    add_foreign_key :moves, :frames
    # add_foreign_key :moves, :prev_frames

    add_foreign_key :modeles, :manufacturers
    add_foreign_key :modeles, :architectures
    add_foreign_key :modeles, :categories

    # add_foreign_key :memory_components, :servers
    add_foreign_key :memory_components, :memory_types

    add_foreign_key :maintenance_contracts, :maintainers
    add_foreign_key :maintenance_contracts, :contract_types
    add_foreign_key :maintenance_contracts, :servers

    # add_foreign_key :rooms, :sites

    # add_foreign_key :islets, :rooms

    add_foreign_key :frames, :bays

    # add_foreign_key :enclosures, :modeles

    add_foreign_key :documents, :servers

    # add_foreign_key :disks, :servers
    add_foreign_key :disks, :disk_types

    # add_foreign_key :connections, :ports
    add_foreign_key :connections, :cables

    add_foreign_key :cards, :card_types
    # add_foreign_key :cards, :servers
    # add_foreign_key :cards, :composants

    add_foreign_key :bays, :bay_types
    add_foreign_key :bays, :islets

    # add_foreign_key :composants, :enclosures
    add_foreign_key :composants, :type_composants

    add_foreign_key :servers, :frames
    add_foreign_key :servers, :gestions
    # add_foreign_key :servers, :domaines
    add_foreign_key :servers, :modeles
    add_foreign_key :servers, :clusters
    add_foreign_key :servers, :server_states
    add_foreign_key :servers, :stacks

    add_foreign_key :card_types, :port_types
  end
end

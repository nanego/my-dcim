# frozen_string_literal: true

class AddLatestMissingForeignKeysToExistingTables < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :ports, :cards

    add_foreign_key :moved_connections, :port_froms
    add_foreign_key :moved_connections, :port_tos

    add_foreign_key :islets, :rooms

    add_foreign_key :enclosures, :modeles

    add_foreign_key :connections, :ports

    add_foreign_key :cards, :servers
    add_foreign_key :cards, :composants

    add_foreign_key :composants, :enclosures

    add_foreign_key :servers, :frames
    add_foreign_key :servers, :domaines
  end
end

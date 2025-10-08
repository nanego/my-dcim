# frozen_string_literal: true

class MigrationPortType < ActiveRecord::Base
  self.table_name = :port_types
end

class CreateCards < ActiveRecord::Migration[4.2]
  def change
    create_table :cards do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :name
      t.integer :port_type_id
      t.integer :port_quantity
    end

    create_table :port_types do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :name
    end

    MigrationPortType.create!(name: "FC")
    MigrationPortType.create!(name: "RJ")
    MigrationPortType.create!(name: "VGA")
    MigrationPortType.create!(name: "SCSI")
    MigrationPortType.create!(name: "ISCI")
    MigrationPortType.create!(name: "SAS")
    MigrationPortType.create!(name: "IPMI")
  end
end

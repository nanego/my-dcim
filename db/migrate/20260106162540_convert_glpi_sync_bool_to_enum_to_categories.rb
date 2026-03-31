# frozen_string_literal: true

class MigrationCategory < ActiveRecord::Base
  self.table_name = :categories

  enum :glpi_sync_type, {
    none: 0,
    server: 1,
    network_equipment: 2,
  }, prefix: true
end

class ConvertGlpiSyncBoolToEnumToCategories < ActiveRecord::Migration[8.0]
  def up
    add_column :categories, :glpi_sync_type, :integer, default: 0, null: false

    say_with_time "Backfilling glpi_sync from is_glpi_synchronizable" do
      MigrationCategory.reset_column_information

      MigrationCategory.where(is_glpi_synchronizable: true)
        .update_all(glpi_sync_type: :server)

      MigrationCategory.where(is_glpi_synchronizable: [false, nil])
        .update_all(glpi_sync_type: :none)
    end

    remove_column :categories, :is_glpi_synchronizable
  end

  def down
    add_column :categories, :is_glpi_synchronizable, :boolean, default: false, null: false

    say_with_time "Backfilling is_glpi_synchronizable from glpi_sync" do
      MigrationCategory.reset_column_information

      MigrationCategory.where(glpi_sync_type: :server)
        .update_all(is_glpi_synchronizable: true)

      MigrationCategory.where(glpi_sync_type: %i[none network_equipment])
        .update_all(is_glpi_synchronizable: false)
    end

    remove_column :categories, :glpi_sync_type
  end
end

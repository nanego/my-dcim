# frozen_string_literal: true

class MigrationCategory < ActiveRecord::Base
  self.table_name = :categories
end

class ConvertGlpiSyncBoolToEnumOnCategory < ActiveRecord::Migration[8.0]
  def up
    add_column :categories, :glpi_sync_type, :integer, default: 0, null: false

    say_with_time "Backfilling glpi_sync from is_glpi_synchronizable" do
      MigrationCategory.reset_column_information

      MigrationCategory.where(is_glpi_synchronizable: true)
        .update_all(glpi_sync_type: 1)

      MigrationCategory.where(is_glpi_synchronizable: [false, nil])
        .update_all(glpi_sync_type: 0)
    end

    remove_column :categories, :is_glpi_synchronizable
  end

  def down
    add_column :categories, :is_glpi_synchronizable, :boolean, default: false, null: false

    say_with_time "Backfilling is_glpi_synchronizable from glpi_sync" do
      MigrationCategory.reset_column_information

      MigrationCategory.where(glpi_sync_type: 1)
        .update_all(is_glpi_synchronizable: true)

      MigrationCategory.where(glpi_sync_type: [0, 2])
        .update_all(is_glpi_synchronizable: false)
    end

    remove_column :categories, :glpi_sync_type
  end
end

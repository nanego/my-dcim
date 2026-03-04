# frozen_string_literal: true

class ConvertGlpiSyncBoolToEnumOnCategory < ActiveRecord::Migration[8.0]
  def up
    add_column :categories, :glpi_sync, :integer, default: 0, null: false

    say_with_time "Backfilling glpi_sync from is_glpi_synchronizable" do
      Category.reset_column_information

      Category.where(is_glpi_synchronizable: true)
        .update_all(glpi_sync: 1)

      Category.where(is_glpi_synchronizable: [false, nil])
        .update_all(glpi_sync: 0)
    end

    remove_column :categories, :is_glpi_synchronizable
  end

  def down
    add_column :categories, :is_glpi_synchronizable, :boolean, default: false, null: false

    say_with_time "Backfilling is_glpi_synchronizable from glpi_sync" do
      Category.reset_column_information

      Category.where(glpi_sync: 1)
        .update_all(is_glpi_synchronizable: true)

      Category.where(glpi_sync: [0, 2])
        .update_all(is_glpi_synchronizable: false)
    end

    remove_column :categories, :glpi_sync
  end
end

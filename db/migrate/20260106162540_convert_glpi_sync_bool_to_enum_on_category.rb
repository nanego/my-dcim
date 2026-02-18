# frozen_string_literal: true

class ConvertGlpiSyncBoolToEnumOnCategory < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :glpi_sync, :integer, default: 0, null: false

    up_only do
      say_with_time "Backfilling glpi_sync from is_glpi_synchronizable" do
        Category.reset_column_information

        Category.where(is_glpi_synchronizable: true)
          .update_all(glpi_sync: 1)

        Category.where(is_glpi_synchronizable: [false, nil])
          .update_all(glpi_sync: 0)
      end
    end

    remove_column :categories, :is_glpi_synchronizable # rubocop:disable Rails/ReversibleMigration
  end
end

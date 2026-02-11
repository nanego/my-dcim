# frozen_string_literal: true

class ConvertGlpiSyncBoolToEnumOnCategory < ActiveRecord::Migration[8.0]
  def up
    # make sure table categories has no line with is_glpi_synchronizable NULL
    execute "UPDATE categories SET is_glpi_synchronizable = false WHERE is_glpi_synchronizable IS NULL"

    change_table :categories, bulk: true do |t|
      t.rename :is_glpi_synchronizable, :glpi_sync

      # remove default to let rails execute the
      # change column then the change default
      t.change_default :glpi_sync, nil

      t.change :glpi_sync, :integer,
               using: "CASE WHEN glpi_sync THEN 1 ELSE 0 END",
               default: 0,
               null: false
    end
  end

  def down
    change_table :categories, bulk: true do |t|
      t.rename :glpi_sync, :is_glpi_synchronizable

      t.change :is_glpi_synchronizable, :boolean,
               using: "CASE WHEN is_glpi_synchronizable = 1 THEN true ELSE false END",
               default: false,
               null: false
    end
  end
end

# frozen_string_literal: true

class MigrationChangelogEntry < ActiveRecord::Base
  self.table_name = :changelog_entries
end

class RenameGestionsToManagers < ActiveRecord::Migration[8.0]
  def up
    rename_table :gestions, :managers
    rename_column :servers, :gestion_id, :manager_id

    say_with_time "Changing Gestion changelog entries type to Manager" do
      MigrationChangelogEntry.where(object_type: "Gestion")
        .update_all(object_type: "Manager")
    end
  end

  def down
    rename_table :managers, :gestions
    rename_column :servers, :manager_id, :gestion_id

    say_with_time "Changing Manager changelog entries type to Gestion" do
      MigrationChangelogEntry.where(object_type: "Manager")
        .update_all(object_type: "Gestion")
    end
  end
end

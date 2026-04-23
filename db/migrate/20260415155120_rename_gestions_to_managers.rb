# frozen_string_literal: true

class MigrationChangelogEntry < ActiveRecord::Base
  self.table_name = :changelog_entries
end

class RenameGestionsToManagers < ActiveRecord::Migration[8.0]
  def change
    rename_table :gestions, :managers
    rename_column :servers, :gestion_id, :manager_id

    reversible do |dir|
      say_with_time "Updating changelog entries type" do
        dir.up { MigrationChangelogEntry.where(object_type: "Gestion").update_all(object_type: "Manager") }
        dir.down { MigrationChangelogEntry.where(object_type: "Manager").update_all(object_type: "Gestion") }
      end
    end
  end
end

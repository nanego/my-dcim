# frozen_string_literal: true

class MigrationChangelogEntry < ActiveRecord::Base
  self.table_name = :changelog_entries
end

class RenameDomainesToDomains < ActiveRecord::Migration[8.0]
  def change
    drop_view :search_results, revert_to_version: 1

    rename_table :domaines, :domains
    rename_column :servers, :domaine_id, :domain_id
    rename_column :permission_scope_domains, :domaine_id, :domain_id

    create_view :search_results, version: 2

    reversible do |dir|
      say_with_time "Updating changelog entries type" do
        dir.up { MigrationChangelogEntry.where(object_type: "Domaine").update_all(object_type: "Domain") }
        dir.down { MigrationChangelogEntry.where(object_type: "Domain").update_all(object_type: "Domaine") }
      end
    end
  end
end

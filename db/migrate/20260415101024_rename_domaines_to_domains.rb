# frozen_string_literal: true

class MigrationChangelogEntry < ActiveRecord::Base
  self.table_name = :changelog_entries
end

class RenameDomainesToDomains < ActiveRecord::Migration[8.0]
  def up
    drop_view :search_results, revert_to_version: 1

    rename_table :domaines, :domains
    rename_column :servers, :domaine_id, :domain_id
    rename_column :permission_scope_domains, :domaine_id, :domain_id

    say_with_time "Changing Domaine changelog entries type to Domain" do
      MigrationChangelogEntry.where(object_type: "Domaine")
        .update_all(object_type: "Domain")
    end

    create_view :search_results, version: 2
  end

  def down
    drop_view :search_results, revert_to_version: 2

    say_with_time "Changing Domain changelog entries type to Domaine" do
      MigrationChangelogEntry.where(object_type: "Domain")
        .update_all(object_type: "Domaine")
    end

    rename_column :permission_scope_domains, :domain_id, :domaine_id
    rename_column :servers, :domain_id, :domaine_id
    rename_table :domains, :domaines

    create_view :search_results, version: 1
  end
end

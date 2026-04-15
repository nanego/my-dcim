# frozen_string_literal: true

class RenameDomainesToDomains < ActiveRecord::Migration[8.0]
  def change
    rename_table :domaines, :domains
    rename_column :servers, :domaine_id, :domain_id
    rename_column :permission_scope_domains, :domaine_id, :domain_id
  end
end

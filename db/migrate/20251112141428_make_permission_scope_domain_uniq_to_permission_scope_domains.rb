# frozen_string_literal: true

class MakePermissionScopeDomainUniqToPermissionScopeDomains < ActiveRecord::Migration[8.0]
  def change
    add_index :permission_scope_domains, %i[permission_scope_id domaine_id], unique: true
  end
end

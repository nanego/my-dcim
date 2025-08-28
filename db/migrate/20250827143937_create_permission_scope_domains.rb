# frozen_string_literal: true

class CreatePermissionScopeDomains < ActiveRecord::Migration[8.0]
  def change
    create_table :permission_scope_domains do |t|
      t.references :permission_scope, null: false, foreign_key: true
      t.references :domaine, null: false, foreign_key: true

      t.timestamps
    end
  end
end

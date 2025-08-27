# frozen_string_literal: true

class CreatePermissionScopeUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :permission_scope_users do |t|
      t.references :permission_scope, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

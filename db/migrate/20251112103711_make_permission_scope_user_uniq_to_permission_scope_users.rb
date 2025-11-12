# frozen_string_literal: true

class MakePermissionScopeUserUniqToPermissionScopeUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :permission_scope_users, %i[permission_scope_id user_id], unique: true
  end
end

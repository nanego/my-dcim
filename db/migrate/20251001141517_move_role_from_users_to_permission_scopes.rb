# frozen_string_literal: true

require_relative "20250724082513_add_new_roles_to_users"

class MigrationUser < ActiveRecord::Base
  self.table_name = :users

  enum :role, { reader: 0, writer: 1 }, prefix: true
end

class MoveRoleFromUsersToPermissionScopes < ActiveRecord::Migration[8.0]
  def change
    up_only do
      MigrationUser.reset_column_information

      permission_scope = PermissionScope.create!(name: "Editeur ALL", all_domains: true, role: :writer)

      permission_scope.user_ids = MigrationUser.where(role: "writer").ids
      permission_scope.save!
    end

    revert AddNewRolesToUsers
  end
end

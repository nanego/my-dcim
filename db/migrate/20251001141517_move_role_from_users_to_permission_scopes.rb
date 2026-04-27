# frozen_string_literal: true

require_relative "20250724082513_add_new_roles_to_users"

class MigrationUser < ActiveRecord::Base
  self.table_name = :users

  enum :role, { reader: 0, writer: 1 }, prefix: true
end

class MigrationPermissionScopeUser < ActiveRecord::Base
  self.table_name = :permission_scope_users

  belongs_to :user, touch: true, class_name: "MigrationUser"
end

class MigrationPermissionScope < ActiveRecord::Base
  self.table_name = :permission_scopes

  enum :role, { reader: 0, writer: 1 }

  has_many :permission_scope_users, dependent: :destroy, class_name: "MigrationPermissionScopeUser",
                                    foreign_key: :permission_scope_id
  has_many :users, through: :permission_scope_users, class_name: "MigrationUser"
end

class MoveRoleFromUsersToPermissionScopes < ActiveRecord::Migration[8.0]
  def change
    up_only do
      MigrationUser.reset_column_information

      permission_scope = MigrationPermissionScope.create!(name: "Editeur ALL", all_domains: true, role: :writer)

      permission_scope.user_ids = MigrationUser.where(role: "writer").ids
      permission_scope.save!
    end

    revert AddNewRolesToUsers
  end
end

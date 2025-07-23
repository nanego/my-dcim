# frozen_string_literal: true

class MigrationUser < ActiveRecord::Base
  self.table_name = :users

  enum :role, { user: 0, vip: 1, admin: 2 }
end

class AddIsAdminToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :is_admin, :boolean, default: false

    MigrationUser.reset_column_information
    MigrationUser.find_each do |user|
      user.update!(is_admin: true) if user.admin?
    end

    remove_column :users, :role, :integer
  end

  def down
    remove_column :users, :is_admin
    add_column :users, :role, :integer
  end
end

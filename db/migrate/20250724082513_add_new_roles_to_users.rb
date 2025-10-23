# frozen_string_literal: true

class MigrationUser < ActiveRecord::Base
  self.table_name = :users
end

class AddNewRolesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :integer, null: false, default: 0

    up_only do
      MigrationUser.reset_column_information
      MigrationUser.update_all(role: 1)
    end
  end
end

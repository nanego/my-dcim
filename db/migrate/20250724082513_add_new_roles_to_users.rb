# frozen_string_literal: true

class MigrationUser < ActiveRecord::Base
  self.table_name = :users

  enum :role, { reader: 0, writer: 1 }
end

class AddNewRolesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :integer, null: false, default: 0

    up_only do
      MigrationUser.update_all(role: :writer)
    end
  end
end

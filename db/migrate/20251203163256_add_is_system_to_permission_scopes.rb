# frozen_string_literal: true

class AddIsSystemToPermissionScopes < ActiveRecord::Migration[8.0]
  def change
    add_column :permission_scopes, :is_system, :boolean, null: false, default: false
  end
end

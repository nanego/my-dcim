# frozen_string_literal: true

class CreatePermissionScopes < ActiveRecord::Migration[8.0]
  def change
    create_table :permission_scopes do |t|
      t.string :name, null: false
      t.integer :role, null: false, default: 0
      t.boolean :all_domains, null: false, default: false

      t.timestamps
    end
  end
end

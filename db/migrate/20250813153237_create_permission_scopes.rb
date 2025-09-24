# frozen_string_literal: true

class CreatePermissionScopes < ActiveRecord::Migration[8.0]
  def change
    create_table :permission_scopes do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end

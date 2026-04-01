# frozen_string_literal: true

class AddOidcUidToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :oidc_uid, :string
    add_index :users, :oidc_uid, unique: true
  end
end

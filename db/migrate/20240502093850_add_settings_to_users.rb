# frozen_string_literal: true

class AddSettingsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :settings, :jsonb, null: false, default: {}
  end
end

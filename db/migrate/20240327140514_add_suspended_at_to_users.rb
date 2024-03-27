# frozen_string_literal: true

class AddSuspendedAtToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :suspended_at, :datetime
  end
end

# frozen_string_literal: true

class AddExecutedAtToMovedConnections < ActiveRecord::Migration[8.0]
  def change
    add_column :moved_connections, :executed_at, :timestamp
  end
end

# frozen_string_literal: true

class AddMoveReferenceToMovedConnections < ActiveRecord::Migration[8.0]
  def change
    add_reference :moved_connections, :move, null: true, foreign_key: true
  end
end

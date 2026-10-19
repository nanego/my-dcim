# frozen_string_literal: true

class MoveConnectionMigration < ActiveRecord::Base
  self.table_name = :move_connections

  enum :status, { create: 0, update: 1, destroy: 2 }, prefix: true
end

class AddStatusToMoveConnections < ActiveRecord::Migration[8.1]
  def status_for(connection)
    return :destroy if connection.port_to_id.nil?

    connection.port_from.connections.any? ? :update : :create
  end

  def change
    add_column :move_connections, :status, :integer

    up_only do
      MoveConnectionMigration.reset_column_information
      MoveConnectionMigration.find_each do |connection|
        connection.status = status_for(connection)
        connection.save!
      end

      change_column_null :move_connections, :status, false
    end
  end
end

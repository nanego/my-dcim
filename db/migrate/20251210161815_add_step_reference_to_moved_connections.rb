# frozen_string_literal: true

class AddStepReferenceToMovedConnections < ActiveRecord::Migration[8.0]
  def change
    add_reference :moved_connections, :step, null: true, foreign_key: { to_table: :moves_project_steps }
  end
end

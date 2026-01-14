# frozen_string_literal: true

class AddRemoveExistingConnexionsOnExecutionToMoves < ActiveRecord::Migration[8.0]
  def change
    add_column :moves, :remove_existing_connections_on_execution, :boolean, null: false, default: false
  end
end

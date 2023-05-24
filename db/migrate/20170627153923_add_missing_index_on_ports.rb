# frozen_string_literal: true

class AddMissingIndexOnPorts < ActiveRecord::Migration[5.0]
  def change
    add_index :ports, :cards_server_id
  end
end

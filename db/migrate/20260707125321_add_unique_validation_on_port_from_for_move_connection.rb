# frozen_string_literal: true

class AddUniqueValidationOnPortFromForMoveConnection < ActiveRecord::Migration[8.1]
  def change
    add_index :move_connections, %i[move_id port_from_id], unique: true
  end
end

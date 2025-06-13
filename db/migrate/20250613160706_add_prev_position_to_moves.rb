# frozen_string_literal: true

class AddPrevPositionToMoves < ActiveRecord::Migration[8.0]
  def change
    add_column :moves, :prev_position, :integer

    # TODO migration current data for planned moves
  end
end

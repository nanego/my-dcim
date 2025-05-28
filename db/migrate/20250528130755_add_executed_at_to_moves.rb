# frozen_string_literal: true

class AddExecutedAtToMoves < ActiveRecord::Migration[8.0]
  def change
    add_column :moves, :executed_at, :datetime
  end
end

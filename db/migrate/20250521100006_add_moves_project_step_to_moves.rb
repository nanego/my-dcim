# frozen_string_literal: true

class AddMovesProjectStepToMoves < ActiveRecord::Migration[8.0]
  def change
    add_reference :moves, :moves_project_step, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
  end
end

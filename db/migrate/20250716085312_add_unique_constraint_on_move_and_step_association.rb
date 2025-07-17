# frozen_string_literal: true

class AddUniqueConstraintOnMoveAndStepAssociation < ActiveRecord::Migration[8.0]
  def change
    add_index :moves, %i[moves_project_step_id moveable_id moveable_type], unique: true
  end
end

# frozen_string_literal: true

class AddUserAssociationToMoveProject < ActiveRecord::Migration[8.0]
  def change
    add_reference :moves_projects, :created_by, null: true, foreign_key: { to_table: :users }
  end
end

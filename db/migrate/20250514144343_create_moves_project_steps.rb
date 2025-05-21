# frozen_string_literal: true

class CreateMovesProjectSteps < ActiveRecord::Migration[8.0]
  def change
    create_table :moves_project_steps do |t|
      t.references :moves_project, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :position, null: false, default: "1"
      t.date :date

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreateMovesProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :moves_projects do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end

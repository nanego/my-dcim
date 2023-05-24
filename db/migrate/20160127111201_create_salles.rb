# frozen_string_literal: true

class CreateSalles < ActiveRecord::Migration[4.2]
  def change
    create_table :salles do |t|
      t.string :title
      t.text :description
      t.boolean :published

      t.timestamps null: false
    end
  end
end

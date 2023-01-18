# frozen_string_literal: true

class CreateSites < ActiveRecord::Migration[4.2]
  def change
    create_table :sites do |t|
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end

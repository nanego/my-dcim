# frozen_string_literal: true

class AddNewAttributesToIslets < ActiveRecord::Migration[7.2]
  def change
    change_table :islets, bulk: true do |t|
      t.text :description
      t.integer :cooling_mode
    end
  end
end

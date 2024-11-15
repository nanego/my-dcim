# frozen_string_literal: true

class AddNewAttributesToBay < ActiveRecord::Migration[7.2]
  def change
    change_table :bays, bulk: true do |t|
      t.integer :width
      t.integer :depth

      t.references :manufacturer, foreign_key: true
    end
  end
end

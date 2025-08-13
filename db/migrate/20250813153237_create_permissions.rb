# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :name

      t.timestamps
    end
  end
end

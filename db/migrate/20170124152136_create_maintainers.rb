# frozen_string_literal: true

class CreateMaintainers < ActiveRecord::Migration[4.2]
  def change
    create_table :maintainers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

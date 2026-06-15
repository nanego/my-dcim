# frozen_string_literal: true

class CreateCircuits < ActiveRecord::Migration[8.1]
  def change
    create_table :circuits do |t|
      t.references :record, polymorphic: true, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end

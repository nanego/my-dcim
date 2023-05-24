# frozen_string_literal: true

class CreateGestions < ActiveRecord::Migration[4.2]
  def change
    create_table :gestions do |t|
      t.string :title
      t.text :description
      t.boolean :published

      t.timestamps null: false
    end
  end
end

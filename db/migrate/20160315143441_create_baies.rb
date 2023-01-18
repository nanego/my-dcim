# frozen_string_literal: true

class CreateBaies < ActiveRecord::Migration[4.2]
  def change
    create_table :baies do |t|
      t.string :title
      t.integer :u, default: 41
      t.integer :salle_id
      t.integer :ilot

      t.timestamps null: false
    end
  end
end

# frozen_string_literal: true

class CreateCoupleBaies < ActiveRecord::Migration[4.2]
  def change
    create_table :couple_baies do |t|
      t.integer :baie_one_id
      t.integer :baie_two_id

      t.timestamps null: false
    end
  end
end

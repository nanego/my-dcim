# frozen_string_literal: true

class CreatePduOutletGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :pdu_outlet_groups do |t|
      t.integer :pdu_line_id
      t.string :name
      t.integer :nb_of_outlets, default: 12

      t.timestamps null: false
    end
  end
end

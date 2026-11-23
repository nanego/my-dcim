# frozen_string_literal: true

class AddMaxCurrentColorAndPhaseToCircuit < ActiveRecord::Migration[8.1]
  def change
    change_table :power_distribution_unit_circuits, bulk: true do |t|
      t.integer :max_current
      t.string :color
      t.integer :phase
    end
  end
end

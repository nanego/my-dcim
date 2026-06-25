# frozen_string_literal: true

class CreatePowerDistributionUnitSockets < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_unit_sockets do |t|
      t.references :circuit, foreign_key: { to_table: :power_distribution_unit_circuits }, null: false
      t.references :port_type, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end

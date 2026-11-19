# frozen_string_literal: true

class UpdateMaxPowerAttributesOnPowerDistributionUnitType < ActiveRecord::Migration[8.1]
  def change
    change_table :power_distribution_unit_types, bulk: true do |t|
      t.remove :max_power_per_circuit, type: :integer
      t.integer :max_current
    end
  end
end

# frozen_string_literal: true

class CreatePowerDistributionUnitCircuits < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_unit_circuits do |t|
      t.references :record, polymorphic: true, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end

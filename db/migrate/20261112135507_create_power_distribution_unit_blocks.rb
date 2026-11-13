# frozen_string_literal: true

class CreatePowerDistributionUnitBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_unit_blocks do |t|
      t.references :record, polymorphic: true, null: false
      t.integer :position

      t.timestamps

      t.index %i[record_id position], unique: true
    end
  end
end

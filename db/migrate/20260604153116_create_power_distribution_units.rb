# frozen_string_literal: true

class CreatePowerDistributionUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_units do |t|
      t.references :type, null: false, foreign_key: { to_table: :power_distribution_unit_types }
      t.references :bay, null: false, foreign_key: true
      t.integer :side, null: false
      t.integer :orientation, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :ipmi_url, null: false
      t.string :serial_number, null: false
      t.text :comment, null: false

      t.timestamps
    end

    add_index :power_distribution_units, :serial_number, unique: true
  end
end

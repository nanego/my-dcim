# frozen_string_literal: true

class CreatePowerDistributionUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_units do |t|
      t.belongs_to :type_id, null: false, foreign_key: true
      t.belongs_to :bay_id, null: false, foreign_key: true
      t.integer :side, null: false
      t.integer :orientation, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :ipmi_url, null: false
      t.string :serial_number, null: false
      t.text :comment, null: false

      t.timestamps
    end
  end
end

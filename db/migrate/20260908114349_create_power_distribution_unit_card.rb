# frozen_string_literal: true

class CreatePowerDistributionUnitCard < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_unit_cards do |t|
      t.references :card_type, null: false, foreign_key: true
      t.references :record, polymorphic: true, null: false
      t.integer :first_position
      t.string :name
      t.string :orientation

      t.timestamps
    end
  end
end

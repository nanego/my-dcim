# frozen_string_literal: true

class PortTypeMigration < ApplicationRecord
  self.table_name = :port_types
end

class RenamePowerToIsPowerForPortType < ActiveRecord::Migration[8.1]
  def change
    rename_column :port_types, :power, :is_power

    create_enum :port_types_usable_by, %w[pdu server]
    add_column :port_types, :usable_by, :enum, enum_type: :port_types_usable_by, array: true

    up_only do
      PortTypeMigration.reset_column_information
      PortTypeMigration.find_each do |port_type|
        port_type.update!(is_power: port_type.name == "ALIM", usable_by: ["server"])
      end
    end

    change_table :port_types, bulk: true do |t|
      t.change_default :is_power, from: nil, to: false
      t.change_null :is_power, false

      t.change_default :usable_by, from: nil, to: []
      t.change_null :usable_by, false
    end
  end
end

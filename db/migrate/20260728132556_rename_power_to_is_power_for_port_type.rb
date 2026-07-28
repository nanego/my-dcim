# frozen_string_literal: true

class PortTypeMigration < ApplicationRecord
  self.table_name = :port_types
end

class RenamePowerToIsPowerForPortType < ActiveRecord::Migration[8.1]
  def change
    rename_column :port_types, :power, :is_power

    create_enum :port_attachable_type, %w[pdu server]
    add_column :port_types, :attachable_to, :enum, enum_type: :port_attachable_type, array: true

    up_only do
      PortTypeMigration.reset_column_information
      PortTypeMigration.find_each do |port_type|
        port_type.update!(is_power: port_type.name == "ALIM", attachable_to: ["server"])
      end
    end

    change_table :port_types, bulk: true do |t|
      t.change_default :is_power, from: nil, to: false
      t.change_null :is_power, false

      t.change_default :attachable_to, from: nil, to: []
      t.change_null :attachable_to, false
    end
  end
end

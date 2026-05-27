# frozen_string_literal: true

class CreatePowerDistributionUnitTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_unit_types do |t|
      t.belongs_to :manufacturer, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :current_type
      t.string :documentation_url
      t.boolean :meter_global, null: false, default: false
      t.boolean :meter_per_socket, null: false, default: false
      t.boolean :meter_per_circuit, null: false, default: false
      t.boolean :socket_control, null: false, default: false
      t.boolean :socket_lock, null: false, default: false
      t.boolean :ip_snmp, null: false, default: false
      t.boolean :ip_modbus, null: false, default: false
      t.boolean :ip_ssh, null: false, default: false
      t.boolean :ip_webui, null: false, default: false
      t.boolean :rs485_modbus, null: false, default: false
      t.integer :max_power_per_circuit

      t.timestamps
    end
  end
end

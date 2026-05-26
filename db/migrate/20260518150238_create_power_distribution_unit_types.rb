# frozen_string_literal: true

class CreatePowerDistributionUnitTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_unit_types do |t|
      t.belongs_to :manufacturer, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :current_type
      t.string :documentation_url
      t.boolean :meter_global, default: false
      t.boolean :meter_per_socket, default: false
      t.boolean :meter_per_circuit, default: false
      t.boolean :socket_control, default: false
      t.boolean :socket_lock, default: false
      t.boolean :ip_snmp, default: false
      t.boolean :ip_modbus, default: false
      t.boolean :ip_ssh, default: false
      t.boolean :ip_webui, default: false
      t.boolean :rs485_modbus, default: false
      t.integer :max_power_per_circuit

      t.timestamps
    end
  end
end

# frozen_string_literal: true

class CreatePowerDistributionUnitTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :power_distribution_unit_types do |t|
      t.belongs_to :manufacturer, null: false, foreign_key: true
      t.string :name
      t.integer :current_type
      t.string :documentation_url
      t.boolean :meter_global
      t.boolean :meter_per_socket
      t.boolean :meter_per_circuit
      t.boolean :socket_control
      t.boolean :socket_lock
      t.boolean :ip_snmp
      t.boolean :ip_modbus
      t.boolean :ip_ssh
      t.boolean :ip_webui
      t.boolean :rs485_modbus
      t.integer :max_power_per_circuit

      t.timestamps
    end
  end
end

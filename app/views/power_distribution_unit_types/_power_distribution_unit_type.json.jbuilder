# frozen_string_literal: true

json.extract! power_distribution_unit_type, :id, :manufacturer_id, :name, :current_type, :documentation_url, :meter_global,
              :meter_per_socket, :meter_per_circuit, :socket_control, :socket_lock, :ip_snmp, :ip_modbus, :ip_ssh, :ip_webui,
              :rs485_modbus, :max_power_per_circuit, :created_at, :updated_at
json.url power_distribution_unit_type_url(power_distribution_unit_type, format: :json)

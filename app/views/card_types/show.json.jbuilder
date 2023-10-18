# frozen_string_literal: true

json.extract! @card_type, :id, :name, :port_type, :port_quantity, :columns, :rows, :max_aligned_ports, :first_position

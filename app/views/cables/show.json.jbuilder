# frozen_string_literal: true

json.extract! @cable, :id, :name, :color, :comments, :special_case, :created_at, :updated_at

json.ports @cable.ports, :id, :vlans, :position, :card_id
json.connections @cable.connections, :id, :port_id

# frozen_string_literal: true

json.extract! @port, :id, :position, :vlans, :color, :cablename, :card, :created_at, :updated_at

json.connection do
  json.extract! @port.paired_connection, :port, :cable
  json.server @port.paired_connection.port.server, :id, :name, :numero
end

json.server do
  json.extract! @port.server, :id, :name, :slug, :numero
  json.modele @port.server.modele, :id, :name
end

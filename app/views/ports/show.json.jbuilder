# frozen_string_literal: true

json.extract! @port, :id, :position, :vlans, :color, :cablename, :card, :connection, :paired_connection, :cable, :created_at, :updated_at

json.server do
  json.extract! @port.server, :id, :name, :slug, :numero
  json.modele @port.server.modele, :id, :name
end

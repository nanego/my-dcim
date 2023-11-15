# frozen_string_literal: true

json.array!(@ports) do |port|
  json.extract! port, :id, :position, :vlans, :card_id
  json.url port_url(port, format: :json)
end

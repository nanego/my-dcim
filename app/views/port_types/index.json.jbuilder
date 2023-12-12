# frozen_string_literal: true

json.array!(@port_types) do |port_type|
  json.extract! port_type, :id, :name, :power
  json.url port_type_url(port_type, format: :json)
end

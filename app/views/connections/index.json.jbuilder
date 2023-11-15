# frozen_string_literal: true

json.array!(@connections) do |connection|
  json.extract! connection, :id, :cable_id, :port_id
end

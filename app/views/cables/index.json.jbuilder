# frozen_string_literal: true

json.array!(@cables) do |cable|
  json.extract! cable, :id, :name, :color
  json.url cable_url(cable, format: :json)
end

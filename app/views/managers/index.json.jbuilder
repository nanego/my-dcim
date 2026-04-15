# frozen_string_literal: true

json.array!(@managers) do |manager|
  json.extract! manager, :id, :name, :description
  json.url manager_url(manager, format: :json)
end

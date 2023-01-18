# frozen_string_literal: true

json.array!(@gestions) do |gestion|
  json.extract! gestion, :id, :name, :description
  json.url gestion_url(gestion, format: :json)
end

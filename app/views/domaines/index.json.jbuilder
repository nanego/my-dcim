# frozen_string_literal: true

json.array!(@domaines) do |domaine|
  json.extract! domaine, :id, :name, :description
  json.url domaine_url(domaine, format: :json)
end

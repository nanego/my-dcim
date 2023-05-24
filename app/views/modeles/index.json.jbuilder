# frozen_string_literal: true

json.array!(@modeles) do |modele|
  json.extract! modele, :id, :name, :description
  json.url modele_url(modele, format: :json)
end

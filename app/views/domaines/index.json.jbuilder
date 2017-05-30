json.array!(@domaines) do |domaine|
  json.extract! domaine, :id, :name, :description, :published
  json.url domaine_url(domaine, format: :json)
end

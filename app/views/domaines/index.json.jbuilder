json.array!(@domaines) do |domaine|
  json.extract! domaine, :id, :title, :description, :published
  json.url domaine_url(domaine, format: :json)
end

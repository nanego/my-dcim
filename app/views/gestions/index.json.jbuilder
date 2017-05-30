json.array!(@gestions) do |gestion|
  json.extract! gestion, :id, :name, :description, :published
  json.url gestion_url(gestion, format: :json)
end

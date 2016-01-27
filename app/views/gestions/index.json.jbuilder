json.array!(@gestions) do |gestion|
  json.extract! gestion, :id, :title, :description, :published
  json.url gestion_url(gestion, format: :json)
end

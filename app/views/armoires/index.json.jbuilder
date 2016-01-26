json.array!(@armoires) do |armoire|
  json.extract! armoire, :id, :title, :description, :published
  json.url armoire_url(armoire, format: :json)
end

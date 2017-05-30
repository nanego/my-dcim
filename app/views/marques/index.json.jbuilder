json.array!(@marques) do |marque|
  json.extract! marque, :id, :name, :description, :published
  json.url marque_url(marque, format: :json)
end

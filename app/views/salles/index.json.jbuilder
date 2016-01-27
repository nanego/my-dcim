json.array!(@salles) do |salle|
  json.extract! salle, :id, :title, :description, :published
  json.url salle_url(salle, format: :json)
end

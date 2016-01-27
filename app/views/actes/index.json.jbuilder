json.array!(@actes) do |acte|
  json.extract! acte, :id, :title, :description, :published
  json.url acte_url(acte, format: :json)
end

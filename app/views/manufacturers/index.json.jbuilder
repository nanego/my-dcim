json.array!(@manufacturers) do |manufacturer|
  json.extract! manufacturer, :id, :name, :description, :published
  json.url manufacturer_url(manufacturer, format: :json)
end

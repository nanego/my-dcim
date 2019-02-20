json.array!(@manufacturers) do |manufacturer|
  json.extract! manufacturer, :id, :name, :description
  json.url manufacturer_url(manufacturer, format: :json)
end

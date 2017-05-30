json.array!(@categories) do |category|
  json.extract! category, :id, :name, :description, :published
  json.url category_url(category, format: :json)
end

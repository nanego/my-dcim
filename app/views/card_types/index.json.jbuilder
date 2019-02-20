json.array!(@card_types) do |card_type|
  json.extract! card_type, :id, :name, :description
  json.url card_type_url(card_type, format: :json)
end

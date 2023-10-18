# frozen_string_literal: true

json.array!(@card_types) do |card_type|
  json.extract! card_type, :id, :name
  json.url card_type_url(card_type, format: :json)
end

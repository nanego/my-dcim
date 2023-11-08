# frozen_string_literal: true

json.array!(@islets) do |islet|
  json.extract! islet, :id, :name, :room
  json.url islet_url(islet, format: :json)
end

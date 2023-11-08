# frozen_string_literal: true

json.array!(@bays) do |bay|
  json.extract! bay, :id, :name
  json.url bay_url(bay, format: :json)
end

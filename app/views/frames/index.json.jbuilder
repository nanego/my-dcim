# frozen_string_literal: true

json.array!(@frames) do |frame|
  json.extract! frame, :id, :name, :bay_id
  json.url frame_url(frame, format: :json)
end

# frozen_string_literal: true

json.array!(@colors) do |color|
  json.extract! color, :id, :parent_type, :parent_id, :code
  json.url color_url(color, format: :json)
end

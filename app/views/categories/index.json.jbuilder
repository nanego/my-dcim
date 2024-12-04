# frozen_string_literal: true

json.array!(@categories) do |category|
  json.extract! category, :id, :name, :description, :is_glpi_synchronizable
  json.url category_url(category, format: :json)
end

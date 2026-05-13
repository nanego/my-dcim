# frozen_string_literal: true

json.array!(@domains) do |domain|
  json.extract! domain, :id, :name, :description
  json.url domain_url(domain, format: :json)
end

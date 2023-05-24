# frozen_string_literal: true

json.array!(@architectures) do |architecture|
  json.extract! architecture, :id, :name, :description
  json.url architecture_url(architecture, format: :json)
end

# frozen_string_literal: true

json.extract! memory_component, :id, :server_id, :memory_type_id, :quantity, :created_at, :updated_at
json.url memory_component_url(memory_component, format: :json)

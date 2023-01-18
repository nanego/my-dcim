# frozen_string_literal: true

json.extract! memory_type, :id, :to_s, :created_at, :updated_at
json.url memory_type_url(memory_type, format: :json)

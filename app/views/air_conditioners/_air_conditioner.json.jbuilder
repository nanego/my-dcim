# frozen_string_literal: true

json.extract! air_conditioner, :id, :status, :last_service, :bay_id, :created_at, :updated_at
json.url air_conditioner_url(air_conditioner, format: :json)

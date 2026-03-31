# frozen_string_literal: true

json.extract! air_conditioner_model, :id, :name, :manufacturer_id, :created_at, :updated_at
json.url air_conditioner_model_url(air_conditioner_model, format: :json)

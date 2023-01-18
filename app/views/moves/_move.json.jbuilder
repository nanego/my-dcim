# frozen_string_literal: true

json.extract! move, :id, :created_at, :updated_at
json.url move_url(move, format: :json)

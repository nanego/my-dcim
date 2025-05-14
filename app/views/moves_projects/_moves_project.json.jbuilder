# frozen_string_literal: true

json.extract! moves_project, :id, :name, :created_at, :updated_at
json.url moves_project_url(moves_project, format: :json)

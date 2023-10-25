# frozen_string_literal: true

json.extract! site, :id, :name, :street, :city, :country, :latitude, :longitude, :created_at, :updated_at
json.url site_url(site, format: :json)
